📘 DOCUMENTATIONS FIRST – Project Development Guidelines

IMPORTANT: This file is part of the project scaffolding and must be read before writing any code or performing integrations.

🧠 PURPOSE

This DOCUMENTATIONS/ directory is the starting point for understanding, planning, and maintaining consistency throughout the development of this project.

All contributors (including AI copilots and scriptwriters) must refer to this documentation first, before:
	•	Writing new scripts
	•	Implementing logic
	•	Integrating features
	•	Committing code changes

🚦 PRIORITY RULE

Copilot and other assistants must treat this folder as the entry point.
No code generation, automation, or logic should be initiated until this README and related planning files have been read and understood.

📋 FILES TO READ FIRST
	•	architecture.md – system design and role of each board/module
	•	firmware-strategy.md – flashing, protocol and board-specific firmware rules
	•	communication-flow.md – TCP/IP, LI-FI, serial, and fallback communication mapping
	•	build-process.md – environment setup, tools from TOOLS/, and build instructions
	•	project-rules.md – coding guidelines, naming conventions, and integration notes

📚 INCLUDED KNOWLEDGE BASE MODULES

This documentation folder also includes sub-repositories and reference materials:

🧪 conda-docs/
	•	Includes: README.md, requirements.txt, pyproject.toml, GitHub workflows, usage guides, and contribution standards.

📄 docs-content-main/
	•	Source content for end-user docs.
	•	Includes: CONTRIBUTING.md, LICENSE.md, static site content, npm dependencies, and templates.

🔧 platformio-docs/
	•	PlatformIO documentation with examples, extensions, advanced board setups, and scripts.
	•	Sphinx-based documentation toolchain with conf.py, index.rst, and build configs.

📘 reference-en/
	•	AsciiDoc-based reference manuals and language guides for embedded development.
	•	Includes: README.adoc, LICENSE.md, drone config, and language support modules.

🖇 WIRING-CORE.DIAGRAM/
	•	Visual circuit diagrams and .mmd source files for LI-FI TX and RX modules.
	•	Exports: PNG previews and Mermaid sketches.

🧰 TOOLS/
	•	All necessary helper tools for flashing, testing, and build process automation.

🛑 DO NOT SKIP THIS FOLDER

If you’re about to generate or automate code/scripts without reading this folder:
	•	STOP
	•	Read this README and the linked documents
	•	Align your actions with the system’s architecture

⸻

✅ Make this your habit: Documentation First. Code Later.
