#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
SOLUTIONS_DIR="$DIR/genai-maf-context-providers/solutions"

passed=0
failed=0
failed_scripts=()

scripts=(
  "simple_agent.py|Simple Agent (hardcoded movie tool)"
  "simple_context_provider.py|Simple Context Provider (user info memory)"
  "fulltext_context_provider.py|Fulltext Context Provider (Neo4j fulltext search)"
  "vector_context_provider.py|Vector Context Provider (Neo4j vector search)"
  "graph_enriched_provider.py|Graph Enriched Provider (vector + graph traversal)"
  "memory_context_provider.py|Memory Context Provider (persistent memory)"
  "memory_tools_agent.py|Memory Tools Agent (memory tools + context provider)"
)

for entry in "${scripts[@]}"; do
  script="${entry%%|*}"
  description="${entry#*|}"

  echo ""
  echo "========================================"
  echo "  $description"
  echo "  $script"
  echo "========================================"
  echo ""

  if python "$SOLUTIONS_DIR/$script"; then
    echo ""
    echo "-- PASSED --"
    ((passed++))
  else
    echo ""
    echo "-- FAILED --"
    ((failed++))
    failed_scripts+=("$script")
  fi
done

echo ""
echo "========================================"
echo "  Summary: $passed passed, $failed failed"
if [ ${#failed_scripts[@]} -gt 0 ]; then
  echo "  Failed: ${failed_scripts[*]}"
fi
echo "========================================"
