# Workshop Token Usage Report

## Recommended Model: GPT-5 Mini

**`gpt-5-mini`** is the recommended default for workshops. It provides better response quality than GPT-5 Nano for the multi-turn tool-calling exercises (memory tools, graph traversal, entity extraction) at a negligible cost difference — **~$3.10 per 100 participants** vs ~$0.60 for Nano. The improved responses are worth it in a learning environment where participants are evaluating agent behavior.

The `.env.example` and all documentation default to `gpt-5-mini`. Instructors can switch to `gpt-5-nano` for cost-sensitive scenarios or `gpt-4o` for maximum quality.

## Per-Solution Breakdown by Model

| Solution | GPT-4o | GPT-5 Mini | GPT-5 Nano |
|---|---:|---:|---:|
| simple_agent.py | **396** | **1,214** | **1,433** |
| simple_context_provider.py | **621** | **2,683** | **3,322** |
| fulltext_context_provider.py | **1,217** | **1,720** | **2,304** |
| vector_context_provider.py | **1,497** | **2,076** | **2,651** |
| graph_enriched_provider.py | **904** | **1,682** | **2,081** |
| memory_context_provider.py | **2,350** | **5,215** | **6,073** |
| memory_tools_agent.py | **4,809** | **11,826** | **11,633** |
| hybrid_provider.py | **1,173** | **2,071** | **2,688** |
| entity_extraction.py | **36** | **38** | **36** |
| reasoning_memory.py | **18** | **18** | **18** |
| gds_integration.py | **2,100** | **9,244** | **5,407** |
| **TOTAL PER PARTICIPANT** | **15,121** | **37,787** | **37,646** |

### Run-to-Run Variance

Token counts vary between runs due to non-deterministic LLM responses. The GPT-5 Mini figures above represent the higher of two measured runs. Embedding-only solutions (`entity_extraction.py`, `reasoning_memory.py`) are deterministic and produce identical counts across runs. Chat-heavy solutions like `gds_integration.py` can vary by up to ±50% depending on tool call patterns chosen by the model. Use the `--log` flag when running the token report to capture detailed output for comparison.

## GPT-5 Tokenizer Difference

GPT-5 models (Nano and Mini) use a different tokenizer than GPT-4o. The same prompts, tool definitions, and context provider content produce **~2.5x more tokens** on GPT-5 models compared to GPT-4o. This was confirmed by running all 11 solutions against each model with the `--model` flag — the content sent and received is identical, but the token counts reported by the API differ significantly.

This means token-based cost comparisons across model families require comparing the **actual dollar cost**, not the raw token count. Despite the higher token counts, GPT-5 Nano remains one of the cheapest options due to its low per-token pricing ($0.05/$0.40 per 1M vs GPT-4o's $2.50/$10.00 per 1M).

Initial testing with a monkey-patched OpenAI SDK produced misleading results because the model override was not propagating correctly — all runs were actually hitting GPT-4o. After switching to the official `ChatResponse.usage_details` API from the Microsoft Agent Framework, the model override worked correctly and revealed the tokenizer difference.

## High Usage Solutions

- **memory_tools_agent.py** — highest consumer across all models (32-38% of total), driven by 20+ API calls across 3 multi-turn queries with memory tools + context provider
- **memory_context_provider.py** — 16-17% of total, 24 API calls across 3 conversation turns with entity extraction
- **gds_integration.py** — 14-17% of total, varies by model due to tool call patterns

None of these are excessive given the multi-turn nature of the exercises. No solutions need modification.

## Cost Estimates Per Participant

Cost depends on the input/output token split, which varies between runs. The GPT-5 Mini estimate below uses the measured split from the latest run (24,273 chat input + 12,264 chat output + 1,250 embedding tokens).

| Model | Input (per 1M) | Output (per 1M) | Cost Per Participant |
|---|---:|---:|---:|
| GPT-5 Nano | $0.05 | $0.40 | **~$0.006** |
| GPT-5 Mini | $0.25 | $2.00 | **~$0.031** |
| GPT-4o-mini | $0.15 | $0.60 | **~$0.011** |
| GPT-4o | $2.50 | $10.00 | **~$0.184** |

## Workshop Planning

| Participants | GPT-5 Nano | GPT-5 Mini | GPT-4o-mini | GPT-4o |
|---:|---:|---:|---:|---:|
| 10 | $0.06 | $0.31 | $0.11 | $1.84 |
| 25 | $0.15 | $0.78 | $0.28 | $4.60 |
| 50 | $0.30 | $1.55 | $0.55 | $9.20 |
| 100 | $0.60 | $3.10 | $1.10 | $18.40 |

### Stress-Test Budget: 500 Participants × 10 Runs Each

To set a max budget cap, assume worst-case usage: 500 participants each running through all solutions 10 times (5,000 effective runs).

| Model | Cost (500 × 10) |
|---|---:|
| GPT-5 Nano | $30 |
| GPT-5 Mini | $155 |
| GPT-4o-mini | $55 |
| GPT-4o | $920 |

**Recommended budget cap: $200** using the default GPT-5 Mini model. This provides ~30% headroom over the $155 estimate and covers edge cases like retries, debugging, or participants running solutions more than 10 times. If using GPT-4o, set the cap to **$1,000**.

## Azure AI Foundry

For Azure-specific token usage, capacity planning, and cost estimates, see [AZURE_TOKENS.md](AZURE_TOKENS.md).

## Running the Token Usage Report

Prerequisites: a `.env` file with valid Neo4j credentials, LLM credentials (OpenAI or Azure), plus the `.venv` virtual environment.

```bash
# Human-readable report (uses current provider/model from .env)
./admin_setup/run_all.sh --tokens

# Override model for a specific run (OpenAI)
./admin_setup/run_all.sh --tokens --model gpt-5-nano
./admin_setup/run_all.sh --tokens --model gpt-5-mini
./admin_setup/run_all.sh --tokens --model gpt-4o

# Run against Azure AI Foundry
./admin_setup/run_all.sh --tokens --provider azure --model gpt-5-mini
./admin_setup/run_all.sh --tokens --provider azure --model gpt-5-nano

# JSON output (for programmatic use)
./admin_setup/run_all.sh --tokens --json
./admin_setup/run_all.sh --tokens --provider azure --model gpt-5-mini --json

# Log detailed solution output to files for review
./admin_setup/run_all.sh --tokens --model gpt-5-mini --log logs/mini-run
./admin_setup/run_all.sh --tokens --model gpt-4o --log logs/4o-run

# Direct Python invocation
.venv/bin/python admin_setup/token_usage_report.py --model gpt-5-nano
.venv/bin/python admin_setup/token_usage_report.py --provider azure --model gpt-5-mini --json
```

The `--provider` flag overrides `LLM_PROVIDER` and sets the correct model environment variable (`OPENAI_RESPONSES_MODEL_ID` for OpenAI, `AZURE_OPENAI_RESPONSES_DEPLOYMENT_NAME` for Azure).

The `--log <dir>` flag writes each solution's detailed output to a separate log file (e.g., `simple_agent.log`, `gds_integration.log`) and saves the full report as `report.txt`. This is useful for comparing runs across models or investigating token count differences.

The report hooks into the Microsoft Agent Framework's `ChatResponse.usage_details` API and the OpenAI Embeddings API to capture token usage from every LLM and embedding call. Solution output goes to stderr; the report goes to stdout.

## Pricing Sources

All pricing as of March 2026:

- [OpenAI API Pricing](https://openai.com/api/pricing/)
- [Azure OpenAI Pricing](https://azure.microsoft.com/pricing/details/cognitive-services/openai-service/)
- [GPT-5 Nano Model](https://platform.openai.com/docs/models/gpt-5-nano) — $0.05 / $0.40 per 1M tokens (input/output)
- [GPT-5 Mini Model](https://platform.openai.com/docs/models/gpt-5-mini) — $0.25 / $2.00 per 1M tokens (input/output)
- Embedding: `text-embedding-3-small` (OpenAI) — $0.02 per 1M tokens
- Embedding: `text-embedding-ada-002` (Azure) — $0.10 per 1M tokens
