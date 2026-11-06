# Retail Data Platform - dbt + Databricks

A **retail analytics** dbt project built with dbt Core and Databricks, implementing the Medallion Architecture (Bronze → Silver → Gold).

![dbt](https://img.shields.io/badge/dbt-1.8.6-orange)
![Databricks](https://img.shields.io/badge/Databricks-Delta%20Lake-red)
![Python](https://img.shields.io/badge/Python-3.11%2B-blue)

## 🌟 Features

### Working today

- **Medallion layers**: Bronze (seeds) → Silver (staging/intermediate) → Gold (marts)
- **13 dbt models**: 3 staging, 4 intermediate, 3 dimensions, 3 facts
- **Tests**: generic tests plus dbt_utils and dbt_expectations checks on sources and models
- **Incremental facts**: marts facts use the `merge` strategy
- **Databricks settings**: marts are Delta tables, with `OPTIMIZE` after each build and `ZORDER` on dimension keys
- **Snapshot**: `customers_snapshot` tracks customer changes (SCD Type 2)
- **Exposures**: 2 BI dashboards documented in `models/exposures.yml`
- **CI**: GitHub Actions runs SQLFluff and `dbt parse` on every push

### Not finished yet

- **dim_customers** reads `stg_customers`, not the snapshot, so it holds the current version only (it is not SCD Type 2)
- **Freshness**: thresholds are set on the sources, but there is no `loaded_at_field`, so dbt doesn't check them
- **Seeds**: `country_codes` and `currency_exchange_rates` are loaded but no model uses them
- **Elementary**: the package is installed, but nothing is configured, so there is no monitoring yet
- **CI**: SQLFluff findings don't fail the build (`continue-on-error`). `dbt build` and the docs deploy only run when Databricks credentials are set as repo secrets, and they aren't yet

## 📊 Data Flow

```
Seeds (Bronze)
    ↓
Staging (Silver) - Basic transformations
    ↓ joins & enrichment
Intermediate (Silver) - Business logic (RFM, metrics)
    ↓ dimensional modeling
Marts (Gold) - Analytics-ready tables
    ↓
BI Dashboards & Reports
```

## 🚀 Quick Start

### Prerequisites
- Python 3.11+
- Databricks workspace with SQL Warehouse
- Databricks personal access token

### Setup

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/ecuadrosg36/retail-data-platform-dbt-databricks.git
cd retail-data-platform-dbt-databricks

# 2. Set up a virtual environment (Recommended)
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# 3. Install core dependencies
pip install -r requirements.txt

# 4. Install dbt packages
dbt deps

# 5. Environment Configuration
# Set your Databricks credentials as environment variables
export DATABRICKS_HOST="your-databricks-host.cloud.databricks.com"
export DATABRICKS_HTTP_PATH="your-sql-warehouse-http-path"
export DATABRICKS_TOKEN="your-personal-access-token"
```

### Execution Step-by-Step

```bash
# 1. Verify connection
dbt debug

# 2. Seed raw data into Bronze layer
# This loads CSV files from seeds/ into Delta tables
dbt seed

# 3. Build the pipeline (Run + Test)
# This executes staging, intermediate, and marts models
dbt build

# 4. Generate and serve documentation
dbt docs generate
dbt docs serve
```

## 📁 Project Structure

```
├── models/
│   ├── staging/          # Bronze → Silver transformations
│   │   ├── stg_orders.sql
│   │   ├── stg_customers.sql
│   │   └── stg_products.sql
│   ├── intermediate/      # Business logic layer
│   │   ├── int_orders_enriched.sql
│   │   ├── int_order_details.sql
│   │   ├── int_customer_orders.sql
│   │   └── int_customer_metrics.sql
│   └── marts/            # Gold layer (analytics-ready)
│       ├── dimensions/
│       │   ├── dim_customers.sql  # current version, RFM segments
│       │   ├── dim_products.sql
│       │   └── dim_dates.sql
│       ├── facts/
│       │   ├── fct_orders.sql
│       │   └── fct_daily_sales.sql  # Incremental
│       └── sales/
│           └── fct_sales.sql
├── snapshots/            # SCD Type 2 tracking
├── macros/               # Custom macros
├── seeds/                # Sample data (Bronze)
├── analysis/             # Ad-hoc SQL (CLV, monthly trend, top products)
└── packages.yml          # dbt packages
```

## 🧪 Testing

Tests are declared in the schema YAML files:

- **Generic tests**: unique, not_null, accepted_values, relationships
- **dbt_expectations**: range and regex checks on the sources
- **dbt_utils**: `accepted_range` and `expression_is_true` checks

```bash
# Run all tests
dbt test

# Run tests for specific model
dbt test --select dim_customers
```

## 🎯 Key Models

### Dimensions
- **dim_customers**: Customer dimension with RFM segmentation (Recency, Frequency, Monetary)
- **dim_products**: Product catalog with price tier categorization
- **dim_dates**: Date dimension with calendar attributes

### Facts
- **fct_orders**: Order-level facts (one row per order)
- **fct_daily_sales**: Daily aggregated metrics (incremental)

### Metrics Included
- Customer lifetime value
- RFM scores and segments
- Order completion rates
- Daily revenue trends
- Product performance

## ⚡ Databricks Optimizations

The project leverages Databricks-specific features:

- **Delta Lake**: marts are written as Delta tables
- **OPTIMIZE**: post-hooks compact files after each build
- **Z-ORDER**: dimensions are clustered on their key column
- **Incremental strategy**: facts use `merge`

## 📚 Documentation

Documentation is generated automatically and includes:

- Model descriptions and lineage
- Column-level documentation
- BI dashboard dependencies (exposures)

Access docs at: `http://localhost:8080` after running `dbt docs serve`

## 🔄 CI/CD

The GitHub Actions workflow:

1. **SQL linting** with SQLFluff (reports only, doesn't fail the build)
2. **`dbt parse`** checks models, refs and tests without a warehouse
3. **`dbt build`** runs only when Databricks secrets are set
4. **Docs deployment** to GitHub Pages, on `main`, only when Databricks is set up

## 📈 Monitoring

Not set up yet. The Elementary package is in `packages.yml`, but its models and alerts aren't configured.

## 🛠️ Development

```bash
# Create new model
dbt run --select +my_new_model

# Test modified models only
dbt test --select state:modified+

# Generate source YAML
dbt run-operation generate_source --args '{"schema_name": "bronze"}'

# Snapshot changes
dbt snapshot
```

## 🚢 Deployment

### Dev Environment
```bash
dbt build --target dev
```

### Production
```bash
dbt build --target prod
```

## 📝 License

MIT License

---

**Built with ❤️ using dbt + Databricks**
