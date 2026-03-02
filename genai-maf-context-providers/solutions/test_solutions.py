def test_simple_agent(test_helpers, monkeypatch):

    output = test_helpers.run_module(
        monkeypatch,
        "simple_agent"
    )

    assert "User:" in output
    assert "Answer:" in output

def test_simple_context_provider(test_helpers, monkeypatch):

    output = test_helpers.run_module(
        monkeypatch,
        "simple_context_provider"
    )

    assert "User:" in output
    assert "Answer:" in output
    assert "Extracted Name:" in output
    assert "Extracted Age:" in output

def test_fulltext_context_provider(test_helpers, monkeypatch):

    output = test_helpers.run_module(
        monkeypatch,
        "fulltext_context_provider"
    )

    assert "User:" in output
    assert "Answer:" in output

def test_vector_context_provider(test_helpers, monkeypatch):

    output = test_helpers.run_module(
        monkeypatch,
        "vector_context_provider"
    )

    assert "User:" in output
    assert "Answer:" in output

def test_graph_enriched_provider(test_helpers, monkeypatch):

    output = test_helpers.run_module(
        monkeypatch,
        "graph_enriched_provider"
    )

    assert "User:" in output
    assert "Answer:" in output

def test_memory_context_provider(test_helpers, monkeypatch):

    output = test_helpers.run_module(
        monkeypatch,
        "memory_context_provider"
    )

    assert "User:" in output
    assert "Assistant:" in output
    assert "Messages:" in output
    assert "Entities:" in output
    assert "Preferences:" in output

def test_memory_tools_agent(test_helpers, monkeypatch):

    output = test_helpers.run_module(
        monkeypatch,
        "memory_tools_agent"
    )

    assert "User:" in output
    assert "=== Stored Memories ===" in output
