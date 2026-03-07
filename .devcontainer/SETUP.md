# Setup

This repository accompanies the [Neo4j Context Providers for Microsoft Agent Framework workshop](https://graphacademy.neo4j.com/courses/genai-maf-context-providers/) on [GraphAcademy](https://graphacademy.neo4j.com).

All required software and packages have been installed automatically.

## 1. Create a Neo4j Sandbox

1. Go to [sandbox.neo4j.com](https://sandbox.neo4j.com)
2. Sign in or create a free account
3. Select the **Recommendations** dataset and create a new sandbox
4. Note the **Connection details** (Bolt URL, username, password)

## 2. Configure Environment Variables

1. Create a new `.env` file by copying the example:

```bash
cp .env.example .env
```

2. Open `.env` and update with your credentials:
   - `OPENAI_API_KEY` — Your OpenAI API key from [platform.openai.com](https://platform.openai.com), or use the key provided by your instructor
   - `NEO4J_URI` — The Bolt URI from your Neo4j Sandbox (e.g. `neo4j+s://xxxxx.databases.neo4j.io`)
   - `NEO4J_USERNAME` — Usually `neo4j`
   - `NEO4J_PASSWORD` — The password from your Neo4j Sandbox

> **Tip:** If you configured secrets when launching the Codespace, those values are already available as environment variables. You still need to create the `.env` file for scripts that use `python-dotenv`.

## 3. Verify Your Setup

Run the test script to confirm your connections are working:

```bash
python genai-maf-context-providers/test_environment.py
```

## 4. Start the Labs

The workshop labs are Jupyter notebooks in the `labs/` directory. Open `labs/lab-1-first-agent.ipynb` to get started.
