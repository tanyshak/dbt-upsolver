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

from dbt.adapters.sql import SQLConnectionManager as connection_cls
from dbt.logger import GLOBAL_LOGGER as logger
import pep249
from typing import Optional, Tuple

@dataclass
class UpsolverCredentials(Credentials):
    """
    Defines database specific credentials that get added to
    profiles.yml to connect to new adapter
    """

    token: str
    api_url: Optional[str] = 'https://mt-api-prod.upsolver.com/'

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
        return ("token", "api_url")

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
            

    @classmethod
    def open(cls, connection):
        """
        Receives a connection object and a Credentials object
        and moves it to the "open" state.
        """
        # ## Example ##
        # if connection.state == "open":
        #     logger.debug("Connection is already open, skipping open.")
        #     return connection

        # credentials = connection.credentials

        try:
            logger.debug(f"Start open a connection {cls.__class__.__name__}")
            handle = pep249.connection.connect(
                 api_url = connection.credentials.api_url,
                 token = connection.credentials.token)
            logger.debug(f"Connection is already open {cls.__class__.__name__}")
            connection.state = "open"
            connection.handle = handle
            connection.handle.cursor().execute('select 42 as answer')
        except Exception as e:
            logger.error(f"Connection error {str(e)}")
        return connection

    @classmethod
    def get_response(cls,cursor):
        """
        Gets a cursor object and returns adapter-specific information
        about the last executed command generally a AdapterResponse ojbect
        that has items such as code, rows_affected,etc. can also just be a string ex. "OK"
        if your cursor does not offer rich metadata.
        """
        logger.debug(f"Get_response method {cls.__class__.__name__}")
        # ## Example ##
        # return cursor.status_message
        pass

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
        logger.debug(f"Cancel method {cls.__class__.__name__}")
        pass
