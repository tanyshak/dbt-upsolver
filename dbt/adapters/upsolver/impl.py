
from dbt.adapters.sql import SQLAdapter as adapter_cls

from dbt.adapters.upsolver import UpsolverConnectionManager

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

 # may require more build out to make more user friendly to confer with team and community.
