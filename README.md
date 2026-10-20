# enroll-conflict：实验 1 的统一示例

> 实验要求、任务步骤、检查点和评分见 Canvas 上发布的《实验 1：从提交到可追溯制品的流水线》指导书。本仓库只提供示例代码，不含指导书。

一个仅依赖标准库的小型服务：判断两个教学班的上课时间是否冲突，对应 L-05 课程实践中“冲突检测新规则”的场景。**服务本身不是实验的重点**，它的作用是为流水线提供一个可构建、可测试、可使测试失败的对象。

## 规则

两个教学班冲突，当且仅当：同一个星期、上课周次有交集、节次区间有重叠。上课周次分三种：`all`（每周）、`odd`（单周）、`even`（双周）。单周班与双周班在同一时段上课不冲突。

## 接口

| 方法与路径 | 作用 |
|---|---|
| `GET /healthz` | 存活检查，返回 `ok` |
| `GET /version` | 返回版本号、提交号、构建号、Go 版本（JSON） |
| `POST /api/conflict` | 请求体 `{"a": 教学班, "b": 教学班}`，返回 `{"conflict": true/false}` |

教学班的字段：`id`、`weekday`（1～7）、`start`、`end`（节次，含）、`weeks`。

## 在本地运行

需要 Go 1.26 或更高版本；`make` 目标还需要 GNU make 和 GNU tar（Linux 或 WSL2）。

```bash
make fmt-check vet test                    # quality gate
go run . -addr 127.0.0.1:8080              # 直接运行
make package VERSION=1.0.0 BUILD_NO=1      # 打包到 dist/
dist/enroll-conflict_1.0.0_linux_amd64/enroll-conflict -version
```

`make package` 的参数 `VERSION`、`BUILD_NO`、`COMMIT` 是制品的三个追溯标识，`RUN_ID` 用于指向具体的那次运行；未传入时分别取 `dev`、`local`、本地 `HEAD` 和 `local`，表示“未经过流水线”。

## 复现发布追溯与回退

v1.0.0、v1.0.1 均发布后，在 Linux x86_64 主机上执行：

```bash
git fetch origin main --tags
scripts/verify-release-rollback.sh
```

脚本下载两个版本的原始 Release 附件，核对 `evidence/lab1/v1.0.0.sha256` 中独立保存的发布基线，运行 `trace.sh`，再在同一端口先运行 v1.0.1、后切换至 v1.0.0，并将两次 `/version` 与附件的 `BUILD_INFO` 比较。原始输出保存在 `dist/release/`，全过程无需重新构建。默认端口为 18080，可用 `PORT=18081 scripts/verify-release-rollback.sh` 更换；Linux arm64 主机可通过 `QEMU_X86_64=/绝对路径/qemu-x86_64` 指定用户态模拟器。

本次任务 6 的 PR 小改动是在 `/version` 返回 `Cache-Control: no-store`，并增加回归断言。PR 的 `ci` 通过后，请另一位组员审批，选择 **Squash and merge**；建议提交标题为 `fix: 禁止缓存版本信息并补充实验1记录`。合入以后才执行以下发布命令：

```bash
git switch main
git pull --ff-only origin main
git tag -a v1.0.1 -m "Release v1.0.1"
git push origin v1.0.1
```

等待 `release` 工作流成功，确认 v1.0.1 Release 包含 `.tar.gz` 和 `.tar.gz.sha256` 两个附件后，再运行上述回退脚本。将两份 trace 输出、两次 `/version`、v1.0.0 发布后复核值及 v1.0.1 的提交/PR/运行/校验和填入 `LAB1.md`；这些证据在发布后才产生，补录文件也须经过 PR 合入 main。已经发布的版本不能通过移动 tag 或覆盖附件来更新。

## 文件

| 文件 | 说明 |
|---|---|
| `conflict.go`、`conflict_test.go` | 冲突规则及其测试 |
| `main.go`、`main_test.go` | HTTP 服务、版本信息及其测试 |
| `Makefile` | 本地与 CI 共用的构建入口 |
| `scripts/trace.sh` | 追溯脚本：由制品回答“它来自哪次提交” |
| `scripts/verify-release-rollback.sh` | 下载原始附件，复现发布追溯与回退 |
| `Dockerfile` | 选做 O1 使用 |
| `LAB1.md` | 小组的证据与分析记录，需要填写并提交 |

仓库中没有 `.github/workflows/`：流水线由小组在实验中自行编写。
