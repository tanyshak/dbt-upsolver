## dbt-upsolver-s3-to-athena

Upsolver sample data project transformed to dbt project
<details><summary> Add to profiles.yml the following code(sample data)</summary>
<p>

```yml
s3_to_athena:
  outputs:
    dev:
      database: database_16e61b
      api_url: https://mt-api-prod.upsolver.com/
      schema: default_glue_catalog
      token: token
      threads: 1
      type: upsolver
      user: dev
  target: dev
```
</p>
</details>

### Resources:
- Upsolver documentation [sqlake documentation](https://docs.upsolver.com/sqlake/)
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
