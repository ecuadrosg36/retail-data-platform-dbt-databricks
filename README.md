# Retail Data Platform - dbt + Databricks

A **production-grade retail analytics platform** built with dbt Core and Databricks, implementing the Medallion Architecture (Bronze → Silver → Gold).

![dbt](https://img.shields.io/badge/dbt-1.8.6-orange)
![Databricks](https://img.shields.io/badge/Databricks-Delta%20Lake-red)
![Python](https://img.shields.io/badge/Python-3.11%2B-blue)

## 🌟 Features

- **Medallion Architecture**: Bronze (seeds) → Silver (staging/intermediate) → Gold (marts)
- **20+ dbt Models**: Staging, intermediate, dimensions, and facts
- **Comprehensive Testing**: >80% coverage with dbt_expectations and dbt_utils
- **Incremental Models**: Optimized for large-scale data processing
- **SCD Type 2**: Snapshot-based slowly changing dimensions
- **Databricks Optimizations**: Delta Lake, OPTIMIZE, Z-ORDER clustering
- **CI/CD Pipeline**: GitHub Actions with slim CI and automated docs
- **Data Observability**: Elementary dbt integration for monitoring
- **BI Exposures**: Documented dashboard dependencies

## 📊 Data Flow

```
Seeds (Bronze)
    ↓ source freshness checks
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

```bash
# Clone and install
git clone <repo>
cd retail_data_platform_dbt_databricks
pip install -r requirements.txt

# Install dbt packages
dbt deps

# Configure Databricks connection
export DATABRICKS_TOKEN=your_token_here
# Edit profiles.yml with your host and http_path
```

### Run Pipeline

```bash
# Load seed data
dbt seed

# Run all models
dbt run

# Run tests
dbt test

# Build everything (run + test)
dbt build

# Generate documentation
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
│   │   └── int_customer_metrics.sql
│   └── marts/            # Gold layer (analytics-ready)
│       ├── dimensions/
│       │   ├── dim_customers.sql  # SCD Type 2
│       │   ├── dim_products.sql
│       │   └── dim_dates.sql
│       └── facts/
│           ├── fct_orders.sql
│           └── fct_daily_sales.sql  # Incremental
├── snapshots/            # SCD Type 2 tracking
├── macros/               # Custom macros
├── seeds/                # Sample data (Bronze)
├── tests/                # Custom tests
└── packages.yml          # dbt packages
```

## 🧪 Testing

The project includes comprehensive data quality tests:

- **Generic Tests**: unique, not_null, accepted_values, relationships
- **dbt_expectations**: Range checks, regex validation, row count monitoring
- **dbt_utils**: Expression validation, equality checks, recency tests
- **Custom Tests**: Business rule validation

```bash
# Run all tests
dbt test

# Run tests for specific model
dbt test --select dim_customers

# Run only schema tests
dbt test --data
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

- **Delta Lake**: All models use Delta format
- **OPTIMIZE**: Post-hooks for automatic file compaction
- **Z-ORDER**: Clustering on primary keys
- **Liquid Clustering**: (Databricks Runtime 13+)
- **Incremental Strategies**: Merge for efficient updates
-**Photon**: Optimized for analytical queries

## 📚 Documentation

Documentation is generated automatically and includes:

- Model descriptions and lineage
- Column-level documentation
- Business glossary
- Test coverage
- BI dashboard dependencies (exposures)

Access docs at: `http://localhost:8080` after running `dbt docs serve`

## 🔄 CI/CD

GitHub Actions workflow includes:

1. **SQL Linting** (sqlfl uff)
2. **Slim CI** (only modified models)
3. **Automated Testing** (all models + tests)
4. **Docs Deployment** (GitHub Pages)

## 📈 Monitoring

Elementary dbt integration provides:

- Data anomaly detection
- Schema change tracking
- Test failure alerts
- Lineage visualization
- Slack/email notifications

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
