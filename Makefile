.PHONY: build tests install clean dev lint

all: dev tests build

install:
	uv sync

dev:
	uv sync --group dev

lint:
	uv run ruff format --check .
	uv run ruff check .
	uv run ty check quantinuum_qircheck tests

tests:
	uv run pytest

build:
	uv build

clean:
	rm -rf .coverage .pytest_cache .ruff_cache build dist htmlcov wheelhouse *.egg-info
