
from dbt.adapters.sql import SQLAdapter as adapter_cls

from dbt.adapters.upsolver import UpsolverConnectionManager

from dbt.events import AdapterLogger

from dbt.adapters.base import BaseAdapter

from dbt.events.functions import fire_event

logger = AdapterLogger("Upsolver")

from dbt.adapters.base.relation import BaseRelation

import agate

from typing import Any, List

LIST_RELATIONS_MACRO_NAME = "list_relations_without_caching"

#from dbt.adapters.base.impl import BaseAdapter

class UpsolverAdapter(adapter_cls):
    """
    Controls actual implmentation of adapter, and ability to override certain methods.
    """

    ConnectionManager = UpsolverConnectionManager

    @classmethod
    def date_function(cls):
        """
        Returns canonical date func
        """
        return "datenow()"

    def debug_query(self) -> None:
        self.execute('SELECT * FROM SystemTables.logs.task_executions limit 1;')

    def create_schema(self, relation: BaseRelation) -> None:
        logger.debug(f"+++++++++++++++++++++++++++++++++")
        logger.debug(f"Pass create schema")
        pass

    def drop_schema(self, relation: BaseRelation) -> None:
        logger.debug(f"+++++++++++++++++++++++++++++++++")
        logger.debug(f"Pass drop schema")
        pass


    def list_relations_without_caching(
        self,
        schema_relation: BaseRelation,
        ) -> List[BaseRelation]:
        kwargs = {"schema_relation": schema_relation}
        # Replace with upsolwer query relations list
        #results = self.execute_macro(LIST_RELATIONS_MACRO_NAME, kwargs=kwargs)

        relations = []
        quote_policy = {"database": True, "schema": True, "identifier": True}
        _type = "connection"
        try:
            _type = self.Relation.get_relation_type(_type)
        except ValueError:
            _type = self.Relation.External
        relations= [self.Relation.create(
                database="default_glue_catalog",
                schema="database_16e61b",
                identifier="table_name",
                quote_policy=quote_policy,
                type=_type
            )]
        return relations


 # may require more build out to make more user friendly to confer with team and community.
