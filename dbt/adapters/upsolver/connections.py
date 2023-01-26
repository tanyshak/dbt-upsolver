from contextlib import contextmanager
from dataclasses import dataclass
from types import TracebackType
from dbt.exceptions import (
    InternalException,
    RuntimeException,
    FailedToConnectException,
    DatabaseException,
)
from dbt.adapters.base import Credentials
from dbt.contracts.connection import AdapterResponse

from dbt.adapters.sql import SQLConnectionManager as connection_cls
#rom dbt.logger import GLOBAL_LOGGER as logger
import upsolver
from typing import Optional, Tuple
from dbt.events import AdapterLogger
import dbt

from dbt.contracts.connection import Connection, ConnectionState, AdapterResponse
import agate
import dbt.clients.agate_helper

logger = AdapterLogger("Upsolver")

@dataclass
class UpsolverAdapterResponse(AdapterResponse):
    query_id: str = ""

@dataclass
class UpsolverCredentials(Credentials):
    """
    Defines database specific credentials that get added to
    profiles.yml to connect to new adapter
    """

    token: str
    api_url: str
    database: str


    #_ALIASES = {"dbname": "database", "schema": "database"}

    @property
    def type(self):
        return "upsolver"

    @property
    def unique_field(self):
        """
        Hashed and included in anonymous telemetry to track adapter adoption.
        Pick a field that can uniquely identify one team/organization building with this adapter
        """
        return self.token

    def _connection_keys(self):
        """
        List of keys to display in the `dbt debug` output.
        """
        return ("token", "api_url", "database")

class UpsolverConnectionManager(connection_cls):
    TYPE = "upsolver"


    @contextmanager
    def exception_handler(self, sql: str):
        """
        Returns a context manager, that will handle exceptions raised
        from queries, catch, log, and raise dbt exceptions it knows how to handle.
        """
        try:
            yield
        except Exception as e:
            logger.error(f"Exception when running SQL: \"{sql}\"")
            logger.exception(e)
            logger.exception(e.with_traceback(None))
            raise dbt.exceptions.DatabaseException(str(e))

    @classmethod
    def open(cls, connection):
        """
        Receives a connection object and a Credentials object
        and moves it to the "open" state.
        """

        if connection.state == "open":
            logger.debug("Connection is already open, skipping open.")
            return connection

        credentials = connection.credentials

        try:
            logger.debug(f"Start open a connection {cls.__class__.__name__}")
            handle = upsolver.connection.connect(
                 api_url = credentials.api_url,
                 token = credentials.token)
            logger.debug(f"Connection is already open {cls.__class__.__name__}")
            logger.debug(f"Credentials: {credentials}")
            connection.state = "open"
            connection.handle = handle
        except Exception as e:
            logger.error(f"Connection error {str(e)}")
        logger.debug(f"Connection: {connection}")
        return connection

#    @classmethod
    def get_response(cls,cursor):
        """
        Gets a cursor object and returns adapter-specific information
        about the last executed command generally a AdapterResponse ojbect
        that has items such as code, rows_affected,etc. can also just be a string ex. "OK"
        if your cursor does not offer rich metadata.
        """
        logger.debug(f"Get_response method {cls.__class__.__name__}")

        code =  "OK" # cursor.sqlstate
        rows = 1 #cursor.rowcount
        status_message = f"{code} {rows}"
        return AdapterResponse(
            _message=status_message,
            code=code,
            rows_affected=rows
        )

    def get_res(self,cursor):
        return cursor.fetchmany()

    #def execute(self, sql, auto_begin=False, fetch=False):
        #logger.debug(f"Start execute")
        #_, cursor = self.add_query(sql, auto_begin)
        #status = self.get_response(cursor)
        #logger.debug(f"Fetch one: {get_res(cursor)}")
        #logger.debug(f"result_from_cursor")
        #table = self.get_result_from_cursor(cursor)
        #logger.debug(f"Results: {table}")

        #return status, table

    def execute(
        self, sql: str, auto_begin: bool = False, fetch: bool = False
    ) -> Tuple[AdapterResponse, agate.Table]:
        logger.debug(f"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
        logger.debug(f"@@@@@Start execute SQL @@@@: {sql}")
        sql = self._add_query_comment(sql)
        _, cursor = self.add_query(sql, auto_begin)
        response = self.get_response(cursor)
        if fetch:
            table = self.get_result_from_cursor(cursor)
        else:
            table = dbt.clients.agate_helper.empty_table()
        logger.debug(f"Responce: {response}")
        logger.debug(f"table: {table}")
        logger.debug(f"fetchmany: {self.get_res(cursor)}")
        logger.debug(f"get_response: {self.get_response(cursor)}")
        return response, table

    def cancel(self, connection):
        """
        Gets a connection object and attempts to cancel any ongoing queries.
        """
        # ## Example ##
        # tid = connection.handle.transaction_id()
        # sql = "select cancel_transaction({})".format(tid)
        # logger.debug("Cancelling query "{}" ({})".format(connection_name, pid))
        # _, cursor = self.add_query(sql, "master")
        # res = cursor.fetchone()
        # logger.debug("Canceled query "{}": {}".format(connection_name, res))
        logger.debug(f"Cancel method {connection}")

    def add_begin_query(self, *args, **kwargs):
        pass

    def add_commit_query(self, *args, **kwargs):
        pass

    def begin(self):
        pass

    def commit(self):
        pass

    def clear_transaction(self):
        pass
