#!/bin/bash

# Build presentation
pandoc QuantQual.md -t beamer -o QuantQual.pdf

# Build pdf (with notes)
pandoc QuantQual.md -o QuantQual-notes.pdf
