
from dataclasses import dataclass
from typing import Optional, Type

#from dbt.adapters.postgres import PostgresRelation
from dbt.adapters.base import BaseRelation
from dbt.dataclass_schema import StrEnum
from dbt.utils import classproperty


class UpsolverRelationType(StrEnum):
    # Built-in materialization types.
    Table = "table"
    View = "view"
    CTE = "cte"
    External = "external"

    # Materialize-specific materialization types.
    Connection = "connection"
    MaterializedView = "materializedview"
    Job = "job"
    Uptable = "uptable"

@dataclass(frozen=True, eq=False, repr=False)
class UpsolverRelation(BaseRelation):
    type: Optional[UpsolverRelationType] = None

    # Materialize does not have a 63-character limit for relation
    # names, unlike PostgreSQL (see dbt-core #2727)
    def relation_max_name_length(self):
        return 16384

    @classproperty
    def get_relation_type(cls) -> Type[UpsolverRelationType]:
        return UpsolverRelationType
