RUBY_VERSION := ruby$(shell grep TargetRubyVersion .rubocop.yml | awk '{print $$2}')

.PHONY: fix
fix:
	docker run --rm -v $$(pwd):$$(pwd) -w $$(pwd) naoigcat/rubocop:${RUBY_VERSION} --debug --autocorrect-all

.PHONY: lint
lint:
	docker run --rm -v $$(pwd):$$(pwd) -w $$(pwd) naoigcat/rubocop:${RUBY_VERSION} --debug --extra-details
