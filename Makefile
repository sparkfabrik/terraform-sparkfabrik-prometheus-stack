.PHONY: lint

lint:
	docker run --rm -v $${PWD}:/data -t ghcr.io/terraform-linters/tflint
