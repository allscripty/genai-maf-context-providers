# Setup

This repository accompanies the [Neo4j Context Providers for Microsoft Agent Framework workshop](https://graphacademy.neo4j.com/courses/genai-maf-context-providers/) on [GraphAcademy](https://graphacademy.neo4j.com).

All required software and packages have been installed automatically.

## Check Your .env

If you entered your credentials as Codespaces secrets when launching, your `.env` file has been generated automatically.

If not, create one manually:

```bash
cp .env.example .env
```

Then update it with your Neo4j Sandbox and OpenAI credentials.

## Verify Your Setup

Run the test script to confirm your connections are working:

```bash
python genai-maf-context-providers/test_environment.py
```

## Start the Labs

The workshop labs are Jupyter notebooks in the `labs/` directory. Open `labs/lab-1-first-agent.ipynb` to get started.
