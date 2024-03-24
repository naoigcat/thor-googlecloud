.PHONY: rubocop
rubocop:
	docker run --rm -v $$(pwd):$$(pwd) -w $$(pwd) naoigcat/rubocop:latest -d -E
