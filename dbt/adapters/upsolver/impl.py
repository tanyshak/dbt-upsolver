
from dbt.adapters.sql import SQLAdapter as adapter_cls

from dbt.adapters.upsolver import UpsolverConnectionManager

from dbt.events import AdapterLogger

logger = AdapterLogger("Upsolver")

from dbt.adapters.upsolver.relation import UpsolverRelation

import agate

import datetime

from typing import Any, List, Optional

from dbt.adapters.base.meta import available

import re

LIST_RELATION_MACRO_NAME = "list_relation_without_caching"


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

    @available
    def alter_datetime(self):
        datetime_now = datetime.datetime.now()
        return 'Altered: ' + datetime_now.strftime('%Y-%m-%d %H:%M:%S')

    @available
    def get_connection_from_sql(self, sql):
        connection_identifier = re.search('"(.*)"', sql).group().split('.')[2] \
                                  .translate(str.maketrans({'\"':'', '\'':''}))

        return connection_identifier

    @available
    def get_columns_names_with_types(self, list_dict):
        res = []
        for col in list_dict:
            if col.get('type'):
                res.append(f"{col['field']} {col['type']}")
        return ', '.join(set(res))

    @available
    def get_columns_names(self, list_dict):
        res = []
        for col in list_dict:
            res.append(col['field'])
        return ', '.join(set(res))


    def list_relations_without_caching(
        self,
        schema_relation: UpsolverRelation,
        ) -> List[UpsolverRelation]:
        materializations = ["table", "job", "connection", "view"]
        results = agate.Table([],[])
        for type in materializations:
            kwargs = {"schema_relation": schema_relation, "relation_type": type}
            result = self.execute_macro(LIST_RELATION_MACRO_NAME, kwargs=kwargs)
            results = agate.Table.merge([results, result])
        relations = []
        quote_policy = {"database": True, "schema": True, "identifier": True}
        for _database, name, _schema, _type in results:
            try:
                _type = self.Relation.get_relation_type(_type)
            except ValueError:
                _type = self.Relation.External
            relations.append(
                self.Relation.create(
                    database=_database,
                    schema=_schema,
                    identifier=name,
                    quote_policy=quote_policy,
                    type=_type,
                )
            )
        return relations
