# 实验 1 记录：第 <组号> 组

现场检查时将打开本文件，按其中的链接核对。证据一律以链接或文本形式给出，不要只贴截图。将 `<填写>` 替换为本组的内容。main 受保护之后，修改本文件也须通过 PR。

## 1. 基本信息

| 项 | 内容 |
|---|---|
| 小组 | 第 <组号> 组 |
| 仓库地址 | <https://github.com/…> |
| 代码载体 | 统一示例 / 自己的项目（<项目名与语言>） |
| runner 与语言版本 | `ubuntu-24.04`，<Go 或其他语言的版本> |
| 合并方式 | <squash / merge commit / rebase> |

## 2. 任务 0：本地基线

| 问题 | 观察结果 |
|---|---|
| 第一次 `make package` 得到的 BUILD_INFO（粘贴） | <填写> |
| 修改一行、不提交，再次打包：BUILD_INFO 是否变化？二进制文件的 sha256 是否变化？（贴出两次的 sha256） | <填写> |
| 两次 `go version -m` 输出中的 vcs 行有何不同？ | <填写> |
| 仅凭 BUILD_INFO，能否回答该包是什么、在哪台机器上、何时、用哪份代码构建？哪一项信息会出错？ | <填写> |

## 3. 证据

| 项 | 链接或文本 |
|---|---|
| 规则集里启用的规则 | [公开分支信息](https://api.github.com/repos/Icecube2017/ops-lab1-4/branches/main)显示 `main` 受保护；尚未取得 Settings → Rulesets 的实际配置，不能据此断言具体规则、审批人数或 bypass 设置。待组长核验并补录 `Restrict deletions`、`Block force pushes`、`Require a pull request before merging`（至少 1 人审批）、`Require status checks to pass`（`ci`）及空 bypass list。以上是课程要求，尚不冒充已核验配置。 |
| 组长直接 `git push origin main` 被拒的终端输出 | 尚未取得本组该次操作的原始终端输出，待组长补录；课程中的示例输出不能作为本组实测证据。 |
| 第一轮：失败的 PR 运行 | [PR #1](https://github.com/Icecube2017/ops-lab1-4/pull/1)；[首次失败 #38717014937](https://github.com/Icecube2017/ops-lab1-4/actions/runs/38717014937)，同一缺陷的[再次失败 #38717249517](https://github.com/Icecube2017/ops-lab1-4/actions/runs/38717249517)。 |
| 第一轮：修复后通过的 PR 运行 | [#38721221556](https://github.com/Icecube2017/ops-lab1-4/actions/runs/38721221556)，分支头 `e918261c40630d70c3dff2062e947fd36b60e8b4`。 |
| 第一轮：合入 main 后的运行（含制品） | [#38735583504](https://github.com/Icecube2017/ops-lab1-4/actions/runs/38735583504)，main 提交 `fe8bc546fe879a37f873985a864b631c02247394`。 |
| 第二轮：找到的缺陷，以及现有测试为何无法发现它 | [PR #4](https://github.com/Icecube2017/ops-lab1-4/pull/4) 的缺陷提交 `56dfb04` 让 `Valid()` 接受必填 `weeks` 缺失后产生的零值空串；旧 `TestValid` 的非法周次只测 `weekly`，冲突用例只构造 `all/odd/even`，没有验证缺失字段。补入 `TestRejectsSectionWithoutWeeks` 后可检出，最后撤销缺陷，只将新增测试合入 main。 |
| 第二轮：仅含缺陷时仍然通过的运行 | [#38843194354](https://github.com/Icecube2017/ops-lab1-4/actions/runs/38843194354)，分支头 `56dfb04c6431bf050b86a4c95e6eb17540896c31`，结论 `success`。 |
| 第二轮：补测试后失败的运行 | [#38844389381](https://github.com/Icecube2017/ops-lab1-4/actions/runs/38844389381)，分支头 `6f331368993c559826a0ec15db592fe4034bb8c9`，结论 `failure`。 |
| 第二轮：撤销缺陷后通过的运行 | [#38844456518](https://github.com/Icecube2017/ops-lab1-4/actions/runs/38844456518)，分支头 `07eed8a75d60bbb3bb407f8248f2be03b03fdb2d`，结论 `success`；随后 squash 为 main 上的 [`6a561b0`](https://github.com/Icecube2017/ops-lab1-4/commit/6a561b0f6a9e858b1072ef06da1ed61c93166935)。 |
| 未合入分支上的 tag 被 release gate 拒绝的运行 | [#39397895544](https://github.com/Icecube2017/ops-lab1-4/actions/runs/39397895544)：`v0.0.1` 指向 `b3f193475ca320b3d4063b718b9aa71df4d1087c`；页面注释为 `Release rejected: commit is not in main history`，9 s 后失败，未创建对应 Release。 |
| Release v1.0.0 | [v1.0.0](https://github.com/Icecube2017/ops-lab1-4/releases/tag/v1.0.0)，由 [release #39395666401](https://github.com/Icecube2017/ops-lab1-4/actions/runs/39395666401) 构建并发布。 |
| Release v1.0.1 | 尚未发布；任务 6 的 PR 审批、合入和发布完成后补录实际链接。 |

第二轮曾有一次先行尝试 [PR #3](https://github.com/Icecube2017/ops-lab1-4/pull/3)，其 [ci #38837827848](https://github.com/Icecube2017/ops-lab1-4/actions/runs/38837827848) 已失败，随后关闭且未合入；它不是“现有测试未发现缺陷”的成功证据。PR #4 在重排提交过程中还有其他运行，以上选用同一条最终提交链的“缺陷通过 → 补测试失败 → 撤销缺陷通过”作为复测证据。

## 4. 追溯与运行

任务 6 状态：已下载、核验并追溯 v1.0.0，已保存其独立 SHA-256 基线；v1.0.1 须等本次 PR 经另一位组员审批并 squash 合入 main 后发布，随后才能实测两个版本的回退。下面的“待执行”不能作为已经完成的证据。

| 项 | v1.0.0 | v1.0.1 |
|---|---|---|
| 版本号 | `1.0.0` | 待发布后读取 BUILD_INFO |
| 构建号 | `1` | 待发布后读取 BUILD_INFO |
| 提交号（SHA） | `bc4b49ed0ea5becd29c643476e65b0b5834fb724` | 待 PR 合入后读取实际 squash 提交 |
| 引入该提交的 PR | [#5](https://github.com/Icecube2017/ops-lab1-4/pull/5) | 本次任务 6 PR，创建后补编号 |
| 构建它的 Actions 运行（`trace.sh` 给出的链接） | [release #39395666401](https://github.com/Icecube2017/ops-lab1-4/actions/runs/39395666401) | 待发布后读取实际 RUN_ID |
| 制品 sha256（取自 Release 的 .sha256，并独立计算核对） | `0d873c5b3c6de56d0de987a81c5760e92840b8bdc7f38d45ef15d6d0ef1cb33b` | 待发布后下载并校验 |

v1.0.0 的附件与校验和均从 [Release v1.0.0](https://github.com/Icecube2017/ops-lab1-4/releases/tag/v1.0.0) 下载；在 v1.0.1 发布前，将原始校验和另存到 [evidence/lab1/v1.0.0.sha256](evidence/lab1/v1.0.0.sha256)，避免后续下载覆盖对照值。Release API 的原附件 digest 也为同一值。原始追溯输出见 [trace-v1.0.0.txt](evidence/lab1/trace-v1.0.0.txt)，本次 `trace.sh` 退出码为 `0`。

仅凭构建号不能唯一确定运行：v1.0.0 的 `build_no=1` 对应 [release 的第 1 次运行 #39395666401](https://github.com/Icecube2017/ops-lab1-4/actions/runs/39395666401)，而 [ci 的第 1 次运行 #38597424522](https://github.com/Icecube2017/ops-lab1-4/actions/runs/38597424522) 是另一提交 `8ef969d4b6e2b0fe305329e250d7f685b2cde2c1` 的构建。`run_number` 按工作流分别计数，应使用 BUILD_INFO 的 `run_id` 定位具体运行；同一次运行的 Re-run 还需结合 `run_attempt` 区分尝试。

发布 v1.0.1 之后重新下载 v1.0.0 的附件，计算得到的 sha256：**待执行**。目前的下载发生在 v1.0.1 发布之前，因此不能提前填成“发布后复核一致”。

`trace.sh` 输出（v1.0.0）：

```text
== 1. 校验和
enroll-conflict_1.0.0_linux_amd64.tar.gz: OK
== 2. 制品里的 BUILD_INFO
name=enroll-conflict
version=1.0.0
build_no=1
run_id=39395666401
commit=bc4b49ed0ea5becd29c643476e65b0b5834fb724
go=go1.26.9
== 3. 提交 bc4b49ed0ea5becd29c643476e65b0b5834fb724
作者: Graham <ningxi1019@gmail.com>
时间: 2026-10-20T16:38:28+08:00
标题: ci: add release workflow for lab1 (#5)
主干: 该提交在 origin/main 的历史上
指向它的 tag: v1.0.0
版本号: 1.0.0    构建号: 1
提交页面（含关联的 PR）: https://github.com/Icecube2017/ops-lab1-4/commit/bc4b49ed0ea5becd29c643476e65b0b5834fb724
构建它的运行: https://github.com/Icecube2017/ops-lab1-4/actions/runs/39395666401
```

`trace.sh` 输出（v1.0.1）：待发布后执行并粘贴原始输出，要求退出码为 0。

任务 6 第 4 步，两次 `/version` 输出：**待 v1.0.1 发布后，以 Release 原附件依次运行并回退，不能用本地 candidate 构建冒充**。可以在 Linux x86_64 主机上执行：

```bash
git fetch origin main --tags
scripts/verify-release-rollback.sh
```

脚本将校验两个附件、比较 v1.0.0 独立基线并运行两个原二进制；结果在 `dist/release/trace-v1.0.0.txt`、`trace-v1.0.1.txt`、`version-v1.0.1.json`、`version-v1.0.0.json` 和 `baseline-check.txt`。将结果补回本节后，才算完成任务 6 检查点。

发布前的单版本运行预检（2026-10-20 18:15:32，UTC+8）：在临时 Alpine Linux 3.23.4 arm64 虚拟机内，使用 QEMU 10.1.5 用户态模拟器运行下载的原始 Linux amd64 二进制。实测 `/healthz` 为 `ok`，`/version` 如下；服务停止后已验证端口关闭，临时虚拟机也已停止。完整命令、架构、文件校验和与输出见 [v1.0.0-runtime.txt](evidence/lab1/v1.0.0-runtime.txt)。这是 v1.0.0 的单独预检，两版本切换仍待发布后执行。

```json
{"version":"1.0.0","commit":"bc4b49ed0ea5becd29c643476e65b0b5834fb724","build_no":"1","go":"go1.26.9"}
```

## 5. 数据

时间统一为北京时间（UTC+8）。PR、提交、审批和 Release 时间取自 GitHub 公开记录；运行时间取自对应 Actions Summary，保留秒级精度。Git 提交时间与推送时间含义不同，以下分别标注。

第一轮 gate 演练的时间线：

| 事件 | 时间（UTC+8） | 链接 |
|---|---|---|
| 发起 PR | 2026-10-15 17:59:28 | [PR #1](https://github.com/Icecube2017/ops-lab1-4/pull/1) |
| 第一次 `ci` 失败（开始 → 结束） | 2026-10-15 17:59:32 → 18:00:01 | [#38717014937](https://github.com/Icecube2017/ops-lab1-4/actions/runs/38717014937) |
| 同一缺陷再次 `ci` 失败（开始 → 结束） | 2026-10-15 18:01:21 → 18:01:51 | [#38717249517](https://github.com/Icecube2017/ops-lab1-4/actions/runs/38717249517) |
| 修复提交的 Git 提交时间（不是推送时间） | 2026-10-15 18:07:41 | [`e918261`](https://github.com/Icecube2017/ops-lab1-4/commit/e918261c40630d70c3dff2062e947fd36b60e8b4) |
| 修复后的 `ci` 通过（开始 → 结束） | 2026-10-15 18:34:23 → 18:34:54 | [#38721221556](https://github.com/Icecube2017/ops-lab1-4/actions/runs/38721221556) |
| 组员审批通过 | 2026-10-15 20:33:30 | [Icecube2017 的审批](https://github.com/Icecube2017/ops-lab1-4/pull/1#pullrequestreview-5533132002) |
| 合入 main | 2026-10-15 20:33:41 | [`fe8bc54`](https://github.com/Icecube2017/ops-lab1-4/commit/fe8bc546fe879a37f873985a864b631c02247394) |

原有记录将修复推送时间填写为 `2026-10-15 18:34:19（UTC+8）`；本次未取得该推送事件的原始记录，保留此说明但不将它当作已复核的测量点。公开 Git 记录中的 `18:07:41` 是提交时间，不能代替推送时间。

提交到发布的间隔：以下三个 PR 的改动均已包含在 v1.0.0 中；第一列时间使用各 PR 第一个提交的 **committer date**，终点使用 Release 的 **published_at**，不把 PR 创建时间或 tag 时间混用为端点。

| PR | 第一个提交的时间（UTC+8） | 合入时间（UTC+8） | 对应 Release 的发布时间（UTC+8） | 提交到发布的间隔 |
|---|---|---|---|---|
| [#1](https://github.com/Icecube2017/ops-lab1-4/pull/1) | [2026-10-15 17:36:04](https://github.com/Icecube2017/ops-lab1-4/commit/3de8f12823499ad7ba886313c6863ead75a84ce7) | 2026-10-15 20:33:41 | [v1.0.0：2026-10-20 16:45:41](https://github.com/Icecube2017/ops-lab1-4/releases/tag/v1.0.0) | 4 天 23 小时 9 分 37 秒（428977 s） |
| [#4](https://github.com/Icecube2017/ops-lab1-4/pull/4) | [2026-10-16 10:09:48](https://github.com/Icecube2017/ops-lab1-4/pull/4/commits/56dfb04c6431bf050b86a4c95e6eb17540896c31) | 2026-10-20 16:36:52 | [v1.0.0：2026-10-20 16:45:41](https://github.com/Icecube2017/ops-lab1-4/releases/tag/v1.0.0) | 4 天 6 小时 35 分 53 秒（369353 s） |
| [#5](https://github.com/Icecube2017/ops-lab1-4/pull/5) | [2026-10-20 13:32:49](https://github.com/Icecube2017/ops-lab1-4/pull/5/commits/626f04103a72be16e93d175747a2abdc093e26ee) | 2026-10-20 16:38:29 | [v1.0.0：2026-10-20 16:45:41](https://github.com/Icecube2017/ops-lab1-4/releases/tag/v1.0.0) | 3 小时 12 分 52 秒（11572 s） |

`ci` 工作流的运行时长：下面是两轮演练所取的完整 7 次样本，均按 Actions 页面的 **Total duration** 记录，包含第一次演练的两次失败，不删除较慢或失败的样本。

| 运行 | 事件（PR / push） | 时长 | 备注（UTC+8） |
|---|---|---|---|
| [#38717014937](https://github.com/Icecube2017/ops-lab1-4/actions/runs/38717014937) | PR #1（缺陷，失败） | 29 s | 10-15 17:59:32 → 18:00:01 |
| [#38717249517](https://github.com/Icecube2017/ops-lab1-4/actions/runs/38717249517) | PR #1（同一缺陷，失败） | 30 s | 10-15 18:01:21 → 18:01:51 |
| [#38721221556](https://github.com/Icecube2017/ops-lab1-4/actions/runs/38721221556) | PR #1（修复，通过） | 31 s | 10-15 18:34:23 → 18:34:54 |
| [#38735583504](https://github.com/Icecube2017/ops-lab1-4/actions/runs/38735583504) | push（main，构建并上传制品） | 34 s | 10-15 20:33:43 → 20:34:17 |
| [#38843194354](https://github.com/Icecube2017/ops-lab1-4/actions/runs/38843194354) | PR #4（仅缺陷，通过） | 20 s | 10-16 10:58:58 → 10:59:18 |
| [#38844389381](https://github.com/Icecube2017/ops-lab1-4/actions/runs/38844389381) | PR #4（补测试，失败） | 20 s | 10-16 11:12:56 → 11:13:16 |
| [#38844456518](https://github.com/Icecube2017/ops-lab1-4/actions/runs/38844456518) | PR #4（撤销缺陷，通过） | 30 s | 10-16 11:13:43 → 11:14:13 |

这 7 次合计 194 s，均值 27.7 s，范围 20～34 s；PR 运行未打包，push 运行包含打包，因此不能只凭这组混合样本判断打包或缓存的单独成本。

## 6. 分析问题

每题先列出所用数据（可引用上面的表），再用一段话（4～8 句）写出结论，并说明结论的成立条件。

**问题 1：gate 的收益与成本。** 两轮演练中，gate 拦住了什么，没有拦住什么？用第 5 节的时间线计算：第一轮因失败多花了多少时间，其中等待 `ci` 的时间和人工修改的时间各占多少？一次 `ci` 大约需要多久，在“提交到发布的间隔”中占多大比例？第二轮补充测试之后，还有哪类问题是测试本身无法发现的？

所用数据：第 5 节第一轮时间线、7 次 `ci` 时长及 PR #1/#4/#5 的提交到发布时间；第 3 节 PR #4 的三次复测运行。

第一轮的已有断言使“单周与双周错误地判为冲突”的改动出现红灯，第二轮的缺失 `weeks` 缺陷却先通过自动检查，新增零值校验测试后才失败，说明 gate 能执行规则，而测试覆盖决定它能发现哪些行为。第一轮从发起 PR 到修复通过共 35 分 26 秒，以首次失败结束到修复通过定义“恢复窗口”则为 34 分 53 秒，其中后续两次 `ci` 执行共 61 秒，其余 33 分 52 秒包括人工处理、重新触发及未单独测量的等待，不能全部声称是实际修改代码的时间。没有一次“首次就通过”的同条件对照，不能严格把整个恢复窗口都解释成失败造成的净增成本。绿色到合入又过了 1 小时 58 分 47 秒，审批在合入前 11 秒完成，这部分也不能归为测试失败的成本。7 次样本中一次 `ci` 约 20～34 秒、均值 27.7 秒，以该均值除以 PR #1/#4/#5 的提交到发布间隔，分别约为 0.0065%、0.0075%、0.2395%，表明这次作业的长间隔主要不在单次自动检查。上述比例只表示一次运行相对整个历时的量级，不能代表累计流水线成本或真实团队的交付水平，因为样本少、共享 runner 存在噪声，且 PR 与 push 步骤不同。即使补上零值测试，也只能验证已经写入断言并在测试环境中执行的情形，尚未表达的业务规则、生产依赖变化及未覆盖的性能和安全问题仍需审查、集成测试和运行观测；结论成立还依赖必需检查确实绑定最新提交并且没有 bypass。

**问题 2：PR 中的构建与 main 上的构建。** 在 PR 触发的运行日志中，`github.sha` 与 `pull_request.head.sha` 是否相同？它们能否在 main 的历史中找到？答案与合并方式有关，请写明本组使用的方式。合并之后，main 上这次改动的提交号是哪个？据此说明，为什么待发布的制品只能从 main 上的提交或 tag 构建。

所用数据：[PR #1 的两个分支提交](https://github.com/Icecube2017/ops-lab1-4/pull/1/commits) 为 `3de8f12823499ad7ba886313c6863ead75a84ce7`、`e918261c40630d70c3dff2062e947fd36b60e8b4`；[合入后的单个提交](https://github.com/Icecube2017/ops-lab1-4/commit/fe8bc546fe879a37f873985a864b631c02247394) 为 `fe8bc546fe879a37f873985a864b631c02247394`；`.github/workflows/ci.yml` 在测试前打印四个上下文字段，且 `actions/checkout` 未指定 `ref`。

本组使用 squash，PR #1 的两个分支提交被合成 main 上一个有单一父提交的新提交 `fe8bc546fe879a37f873985a864b631c02247394`，原来的 `e918261…` 不是这次改动在 main 上的身份。按 [GitHub 的 `pull_request` 事件定义](https://docs.github.com/en/actions/reference/workflows-and-actions/events-that-trigger-workflows#pull_request)，默认 checkout 使用 `refs/pull/1/merge`，因此 `github.sha` 表示临时合并提交，而 `github.event.pull_request.head.sha` 表示分支头 `e918261c40630d70c3dff2062e947fd36b60e8b4`，两者通常不同。公开 Actions Summary 和 API 的 `head_sha` 不能代替 `Show run context` 步骤中 `github.sha` 的原始日志，本次尚未取得该历史步骤的逐行日志，因此具体临时合并 SHA 仍待据实补录，不能将推断写成实测。对本次 squash 来说，PR 分支头和临时合并提交均不会作为最终提交保留在 main 的这条线性历史中；若采用 merge commit，分支提交可以保留，结论便不同。main 的 push 构建使用已经合入的 `fe8bc546…`，而 v1.0.0 从包含后续 PR 的 main 提交 `bc4b49ed0ea5becd29c643476e65b0b5834fb724` 构建，由提交记录中的 PR 编号能够继续追溯。待发布制品因此须绑定经审批、检查并合入的 main 提交或其 tag，不能把 PR 临时合并状态的产物直接当成已进入主干的发布版本；这个保证还依赖 release gate 对 tag 祖先关系的检查。

**问题 3：可重复构建。** 在本地同一个提交上按下表构建，记录哈希值。④、⑤ 需临时去掉 Makefile 中 tar 的 `--mtime=@0`，完成后用 `git checkout -- Makefile` 恢复，不要提交。

| 构建 | 条件 | 二进制 sha256 | tar.gz sha256 |
|---|---|---|---|
| ① | `make package`，四个追溯参数固定 | `0e1bf62594e68fbf0a1435796da09404ea0be9e2c95d0eded065912ee631a955` | `cf5198fa52ecfad392be677b9875d64197d5e129308d72bb8d35a9b24fccde71` |
| ② | 与 ① 完全相同，再构建一次 | `0e1bf62594e68fbf0a1435796da09404ea0be9e2c95d0eded065912ee631a955` | `cf5198fa52ecfad392be677b9875d64197d5e129308d72bb8d35a9b24fccde71` |
| ③ | 仅将 `BUILD_NO` 从 7 改为 8 | `73be078d7444d2548e6e907ed041de22b54c77d97dee9408193353f71f4e05d0` | `b85f978029c0577ed58106bdd3115a5ac5ebbc8cbe2500b0e02303a0be04da08` |
| ④ | 去掉 `--mtime=@0`，其余同 ① | `50d95ba729e594dc5eba409b6c36dabf935047259af5f62df6d23751aa5eeb2b` | `f254e8ac45257a720a4f9e1b85e8fd360cfe2b9877315056f2092034fbfb19e6` |
| ⑤ | 同 ④，间隔约 3 秒再构建 | `50d95ba729e594dc5eba409b6c36dabf935047259af5f62df6d23751aa5eeb2b` | `5ccf9e4517a31467e8bc05a19c13355a43d77320d8fc50fdee73068367f63f46` |
| Actions | 对 main 的同一次 push 执行 Re-run all jobs | 待有权限的组员实际比较两次尝试 | 待有权限的组员实际比较两次尝试 |

所用数据：[五次构建的完整记录](evidence/lab1/reproducible-builds.json)。实验在独立的干净克隆上进行，提交固定为 `bc4b49ed0ea5becd29c643476e65b0b5834fb724`，工具为 Go `1.26.9`、GNU tar `1.35` 和 Apple gzip `457.140.3`；宿主为 macOS arm64，交叉编译目标为 `linux/amd64`，不是声称在 Ubuntu 上取得的哈希。固定参数是 `VERSION=1.0.0 BUILD_NO=7 RUN_ID=123 COMMIT=bc4b49ed0ea5becd29c643476e65b0b5834fb724`，③仅改构建号，④⑤仅临时修改该克隆的 Makefile，完成后已经恢复，主工作仓库 Makefile 未改动。

①②的二进制与归档哈希均相同，说明在本次工具链、目标架构、参数、文件权限和工作区状态都相同的条件下，两次构建可重复；不能仅凭同一个提交就推断任意机器和工具版本都能得到相同文件。③将构建号写进二进制和 BUILD_INFO，因此两个哈希都改变。④的二进制不同于①，`go version -m` 的实测结果是 `vcs.revision` 和 `vcs.time` 保持不变，但 `vcs.modified` 从 `false` 变为 `true`（模块构建信息也带 `+dirty`），说明临时修改 Makefile 仍会被 Go 的 VCS 信息记录，不能把二进制差异归因于 tar 时间参数。④⑤的二进制相同而归档不同，因为未固定 tar 的文件修改时间，重写 BUILD_INFO 和二进制的实际时间进入了归档。制品应携带稳定且能追溯的版本、提交、构建号、运行 ID、工具链和目标信息，发布前应要求工作区干净，避免无必要的当前时间、绝对构建路径或随机值破坏重复性。当前 `ci` 把版本编译为 `0.0.0-main`，`release` 则通过 `-ldflags` 把 tag 的版本写进二进制，所以发布时必须再编译，这偏离了跨阶段使用同一个制品的严格“一次构建、多处部署”，代价是额外的编译与测试，以及两次环境和参数可能漂移。对已经生成的某个 Release，部署和回退仍应直接使用同一份附件；Actions Re-run 的哈希比较尚未执行，必须取得两次真实日志，不能以本地结果或理论推断替代该项证据。

**问题 4：发布与回退。** 假设 v1.0.1 发布后发现缺陷，应当如何处理？为什么不应删除 v1.0.1 的 tag、再用同一版本号重新发布？任务 6 中将服务从 v1.0.1 切换回 v1.0.0 时，使用的是哪个文件，是否需要重新构建？请用两次 `/version` 的输出说明。如果改为从源码重新构建 v1.0.0，得到的文件与原附件是否相同（参考问题 3）？最后，如果有人删除 v1.0.0 的附件，换上一个新文件和对应的新 `.sha256`，`trace.sh` 能否发现？本组在第 4 节记录的值能否发现？可以查阅 GitHub 的 Immutable releases 设置的用途。

所用数据：第 4 节记录的 v1.0.0 原附件 SHA-256、BUILD_INFO 和成功追溯输出；问题 3 的五次哈希与 `vcs.modified`；[v1.0.0 Release API](https://api.github.com/repos/Icecube2017/ops-lab1-4/releases/tags/v1.0.0) 当前显示 `immutable=false`。本次尚未取得 v1.0.1 发布后两次 `/version` 的实测输出，以下是操作方案与已有证据能支持的分析，回退实测结论仍待补齐。

若 v1.0.1 发布后发现缺陷，应保留该版本的发布记录并将运行服务切回已经验证的 v1.0.0 附件，修复经 PR、审批和检查后用新版本号（例如 v1.0.2）发布。删除 v1.0.1 的 tag 再复用同一版本号，会让同名版本指向不同提交或不同字节，使下载缓存、使用者和历史记录对“v1.0.1”产生歧义。本实验回退应运行从 `enroll-conflict_1.0.0_linux_amd64.tar.gz` 解出的 `enroll-conflict_1.0.0_linux_amd64/enroll-conflict`，无需重建，且 `/version` 必须返回第 4 节对应的 `version=1.0.0`、`build_no=1`、`commit=bc4b49ed0ea5becd29c643476e65b0b5834fb724`；这些是待实测核对的目标，不能冒充已经取得的输出。问题 3 已表明源码提交相同仍不足以保证重建文件与原附件相同，只有工具链、所有编译输入、元数据、工作区状态及归档条件都相同时才有可重复的前提，因此回退直接使用原附件更可靠。`trace.sh` 只会检查附件与当前同目录 `.sha256` 一致、声明的提交存在且属于主干，因此如果附件与 `.sha256` 同时被换掉并保留合法的 BUILD_INFO，它可能仍然成功，无法独立认证附件由所声称的 Actions 运行构建。第 4 节在新版本发布前另存的原始 SHA-256 能在新文件字节改变时发现替换，前提是这份独立记录本身可信且没有一起被篡改。[GitHub Immutable releases](https://docs.github.com/en/code-security/concepts/supply-chain-security/immutable-releases) 能锁定发布附件及关联 tag 并生成 release attestation，但本组当前的 v1.0.0 并未启用该保护，不能把产品提供的能力写成本组已经具有的保证。

## 7. 选做记录

| 选做 | 完成情况与证据 |
|---|---|
| O1 容器镜像 | 未做；未发布 GHCR 镜像，也没有镜像 digest 与按 digest 运行的证据。 |
| O2 缓存对反馈时间的影响 | 未做受控对照；现有 `ci.yml` 显式设置 `setup-go.cache: false`，第 5 节是日常运行样本，缺少同条件“有缓存/无缓存各至少 5 次”的数据，不能据此宣称缓存收益。 |
| O3 迁移到小组项目 | 未做；主线使用统一示例 `enroll-conflict`（Go）。 |

## 8. 成员贡献

下表只列已有 PR 页面和审批记录中可核验的 4 个参与账号，不填写姓名；“无”表示截至当前记录尚无证据，不能将审批或别人的 PR 计作本人发起并合入的 PR。

| GitHub 用户名 | 发起并合入的 PR 编号 | 审批过的 PR 编号 |
|---|---|---|
| sugeladi2450 | [#1](https://github.com/Icecube2017/ops-lab1-4/pull/1)、[#2](https://github.com/Icecube2017/ops-lab1-4/pull/2) | 无已核验记录 |
| Vollerei6 | [#4](https://github.com/Icecube2017/ops-lab1-4/pull/4)；[#3](https://github.com/Icecube2017/ops-lab1-4/pull/3) 已关闭未合入，不计入 | 无已核验记录 |
| Graham1019 | [#5](https://github.com/Icecube2017/ops-lab1-4/pull/5) | 无已核验记录 |
| Icecube2017 | 无已核验的本人发起并合入 PR；任务 6 完成后据实更新 | [#1](https://github.com/Icecube2017/ops-lab1-4/pull/1#pullrequestreview-5533132002)、[#2](https://github.com/Icecube2017/ops-lab1-4/pull/2)、[#4](https://github.com/Icecube2017/ops-lab1-4/pull/4)、[#5](https://github.com/Icecube2017/ops-lab1-4/pull/5) |
