import asyncio
import os

from dotenv import load_dotenv
load_dotenv()

from pydantic import SecretStr

from neo4j_agent_memory import MemoryClient, MemorySettings

# tag::settings[]
settings = MemorySettings(
    neo4j={
        "uri": os.environ["NEO4J_URI"],
        "username": os.environ["NEO4J_USERNAME"],
        "password": SecretStr(os.environ["NEO4J_PASSWORD"]),
    },
    extraction={
        "extractor_type": "pipeline",
        "enable_spacy": True,
        "enable_gliner": True,
        "enable_llm_fallback": True,
        "confidence_threshold": 0.5,
        "entity_types": [
            "PERSON", "ORGANIZATION", "LOCATION", "EVENT", "OBJECT"
        ],
    },
)
# end::settings[]

# tag::merge_strategy[]
settings_with_merge = MemorySettings(
    neo4j={
        "uri": os.environ["NEO4J_URI"],
        "username": os.environ["NEO4J_USERNAME"],
        "password": SecretStr(os.environ["NEO4J_PASSWORD"]),
    },
    extraction={
        "extractor_type": "pipeline",
        "merge_strategy": "confidence",
    },
)
# end::merge_strategy[]

# tag::resolution[]
settings_with_resolution = MemorySettings(
    neo4j={
        "uri": os.environ["NEO4J_URI"],
        "username": os.environ["NEO4J_USERNAME"],
        "password": SecretStr(os.environ["NEO4J_PASSWORD"]),
    },
    resolution={
        "strategy": "composite",
        "exact_threshold": 1.0,
        "fuzzy_threshold": 0.85,
        "semantic_threshold": 0.8,
    },
)
# end::resolution[]

# tag::manual_entity[]
async def add_manual_entity():
    async with MemoryClient(settings) as memory_client:
        entity = await memory_client.long_term.add_entity(
            name="Inception",
            entity_type="OBJECT",
            description="2010 science fiction film directed by Christopher Nolan",
            confidence=0.95,
        )
        print(f"Added entity: {entity}")
# end::manual_entity[]

if __name__ == "__main__":
    asyncio.run(add_manual_entity())
