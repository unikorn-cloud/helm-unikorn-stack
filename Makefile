.PHONY: test
test:
	helm lint --strict charts/unikorn-stack
	helm template charts/unikorn-stack > /dev/null
