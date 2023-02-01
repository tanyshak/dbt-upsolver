
from dbt.adapters.sql import SQLAdapter as adapter_cls

from dbt.adapters.upsolver import UpsolverConnectionManager

from dbt.events import AdapterLogger

logger = AdapterLogger("Upsolver")

from dbt.adapters.upsolver.relation import UpsolverRelation

import agate

from typing import Any, List, Optional

from dbt.context.providers import RuntimeConfigObject

LIST_RELATIONS_MACRO_NAME = "list_relations_without_caching"

def get_all_except(self, *except_params):
    if not hasattr(self.model, "config"):
        result = {}
    else:
        result = self.model.config._extra
        for params in except_params:
            result.pop(params, None)
    return result

RuntimeConfigObject.get_all_except = get_all_except


class UpsolverAdapter(adapter_cls):
    """
    Controls actual implmentation of adapter, and ability to override certain methods.
    """

    ConnectionManager = UpsolverConnectionManager
    Relation = UpsolverRelation

    @classmethod
    def date_function(cls):
        """
        Returns canonical date func
        """
        return "datenow()"

    def debug_query(self) -> None:
        self.execute('SELECT * FROM SystemTables.logs.task_executions limit 1;')

    def create_schema(self, relation: UpsolverRelation) -> None:
        pass

    def drop_schema(self, relation: UpsolverRelation) -> None:
        pass


    def list_relations_without_caching(
        self,
        schema_relation: UpsolverRelation,
        ) -> List[UpsolverRelation]:
        kwargs = {"schema_relation": schema_relation}
        # Replace with upsolwer query relations list
        #results = self.execute_macro(LIST_RELATIONS_MACRO_NAME, kwargs=kwargs)
        # Temporary!!!
        return []
