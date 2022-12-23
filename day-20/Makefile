TMPFILE := $(shell mktemp)

part1: file_number.swift part1.swift
	@cat file_number.swift part1.swift > $(TMPFILE) && \
	swift $(TMPFILE)
part2: file_number.swift part2.swift
	@cat file_number.swift part2.swift > $(TMPFILE) && \
	swift $(TMPFILE)
