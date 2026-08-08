# MySOQL2 v1.2 MVP — Salesforce SOQL Desktop Query Tool

A Java Swing REST/HTTP desktop query tool for Salesforce SOQL queries.
**MVP (Minimum Viable Product) edition** — subset of features for essential SOQL work.

## What's in this package

| File | Description |
|------|-------------|
| `mysoql.jar` | Application JAR |
| `mysoql2.sh` | Linux/Mac launcher |
| `mysoql2.bat` | Windows launcher |
| `mysoql.xml` | Application config |
| `mysoql.ini` | JAVA_HOME config |
| `log4j2.xml` | Logging config |
| `misc/` | Runtime dependency jars (Tika, Log4j, Gson, Guava) |

## Requirements

- JDK 17+
- A Salesforce org with OAuth2 connected app credentials

## Quick start

```bash
# Linux/macOS
./mysoql2.sh

# Windows
.\mysoql2.bat
```

If `java` is not on your PATH, set `JAVA_HOME` in `mysoql.ini`.

## MVP Features

This MVP build includes:
- OAuth2 authentication to Salesforce orgs
- SOQL query editor with multi-statement support
- Paginated query results
- Export to XML, CSV, HTML
- Connection browser with org metadata navigation
- Basic CRUD (Insert/Update/Delete) on query results

## Disabled features (MVP)

The following features are disabled in this MVP edition:
- Certificates management
- Detect Encoding (files)
- HTTP Request (REST API)
- Import/Upload/Fetch Content
- Detect Content / Translate Content
- Batch Delete

For full feature access, use the standard [MySOQL2-mvn-releases](https://github.com/amahasintunan/MySOQL2-mvn-releases) edition.

## Oracle support (optional)

Oracle JDBC driver and i18n LCSD jars are NOT bundled (Oracle OTN license). To enable:

1. Download `ojdbc11.jar` from [Oracle JDBC](https://www.oracle.com/database/technologies/appdev/jdbc-downloads.html)
2. Place it in the `misc/` directory
3. The launcher scripts auto-detect it
