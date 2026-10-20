#!/usr/bin/env bash
# 任务 6：下载发布原件，核对基线，追溯，并在同一端口从 1.0.1 回退到 1.0.0。
# 先 git fetch origin main --tags；Linux arm64 可指定绝对路径 QEMU_X86_64。
set -euo pipefail

die() { echo "错误：$*" >&2; exit 1; }
repo=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
out="$repo/dist/release"
repo_url=${REPO_URL:-https://github.com/Icecube2017/ops-lab1-4}
port=${PORT:-18080}
pid=''
stop() {
  if [[ -n $pid ]]; then
    kill "$pid" 2>/dev/null || true
    wait "$pid" 2>/dev/null || true
    pid=''
  fi
}
trap stop EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

[[ $(uname -s) == Linux ]] || die '请在 Linux 上运行发布的 linux/amd64 原始二进制。'
[[ $port =~ ^[0-9]{1,5}$ ]] || die 'PORT 必须是 1～65535。'
port=$((10#$port))
((port >= 1 && port <= 65535)) || die 'PORT 必须是 1～65535。'
runner=()
if [[ -n ${QEMU_X86_64:-} ]]; then
  [[ $QEMU_X86_64 == /* && -x $QEMU_X86_64 ]] || die 'QEMU_X86_64 必须指向可执行文件的绝对路径。'
  runner=("$QEMU_X86_64")
else
  [[ $(uname -m) == x86_64 ]] || die '此架构需要 QEMU_X86_64，或改用 Linux x86_64 主机。'
fi
for tool in curl tar sha256sum git; do command -v "$tool" >/dev/null || die "缺少 $tool"; done
[[ $(tar --version) == *'GNU tar'* ]] || die '需要 GNU tar。'
baseline="$repo/evidence/lab1/v1.0.0.sha256"
[[ -f $baseline ]] || die "缺少独立保存的发布基线：$baseline"
read -r pinned _ < "$baseline"
[[ $pinned =~ ^[[:xdigit:]]{64}$ ]] || die '基线文件第一列必须是 SHA-256。'
git -C "$repo" rev-parse --verify origin/main >/dev/null || die '请先 git fetch origin main --tags。'
mkdir -p "$out"

for v in 1.0.0 1.0.1; do
  name="enroll-conflict_${v}_linux_amd64.tar.gz"
  for suffix in '' .sha256; do
    curl -fL --retry 2 --connect-timeout 15 --max-time 180 \
      -o "$out/$name$suffix" "${repo_url%/}/releases/download/v$v/$name$suffix"
  done
done
sha256sum "$out"/*.tar.gz | tee "$out/archive-sha256.txt"
actual=$(sha256sum "$out/enroll-conflict_1.0.0_linux_amd64.tar.gz")
[[ ${actual%% *} == "$pinned" ]] || die 'v1.0.0 与独立保存的发布时 SHA-256 不同。'
printf 'v1.0.0 独立基线校验通过：%s\n' "$pinned" | tee "$out/baseline-check.txt"
for v in 1.0.0 1.0.1; do
  archive="$out/enroll-conflict_${v}_linux_amd64.tar.gz"
  bash "$repo/scripts/trace.sh" "$archive" "$repo" origin/main | tee "$out/trace-v$v.txt"
  echo 'trace_exit_code=0' | tee -a "$out/trace-v$v.txt"
  tar -xzf "$archive" -C "$out"
done

url="http://127.0.0.1:$port/version"
if curl -sS --connect-timeout 1 --max-time 1 -o /dev/null "$url" 2>/dev/null; then
  die "端口 $port 已有 HTTP 服务；请设置另一个 PORT。"
fi
for v in 1.0.1 1.0.0; do
  pkg="$out/enroll-conflict_${v}_linux_amd64"
  info="$pkg/BUILD_INFO"
  get() { sed -n "s/^$1=//p" "$info"; }
  [[ $(get version) == "$v" ]] || die "v$v 附件内的版本号不符。"
  expected=$(printf '{"version":"%s","commit":"%s","build_no":"%s","go":"%s"}' \
    "$(get version)" "$(get commit)" "$(get build_no)" "$(get go)")
  "${runner[@]}" "$pkg/enroll-conflict" -addr "127.0.0.1:$port" > "$out/service-v$v.log" 2>&1 &
  pid=$!
  ready=false
  : > "$out/curl-v$v.log"
  for ((attempt = 0; attempt < 50; attempt++)); do
    kill -0 "$pid" 2>/dev/null || die "v$v 进程退出；见 $out/service-v$v.log"
    if response=$(curl -fsS --connect-timeout 1 --max-time 1 "$url" 2>> "$out/curl-v$v.log"); then
      ready=true
      break
    fi
    sleep 0.2
  done
  [[ $ready == true ]] || die "v$v 未能在限定时间内就绪。"
  kill -0 "$pid" 2>/dev/null || die "v$v 进程已退出。"
  printf '%s\n' "$response" | tee "$out/version-v$v.json"
  [[ $response == "$expected" ]] || die "v$v /version 与原附件 BUILD_INFO 不符。"
  stop
done
echo "追溯、基线核验与回退全部通过。原始输出：$out"
