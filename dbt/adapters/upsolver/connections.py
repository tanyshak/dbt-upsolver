from contextlib import contextmanager
from dataclasses import dataclass
from dbt.exceptions import (
    InternalException,
    RuntimeException,
    FailedToConnectException,
    DatabaseException,
)
from dbt.adapters.base import Credentials

from dbt.adapters.sql import SQLConnectionManager as connection_cls

from dbt.logger import GLOBAL_LOGGER as logger

from  pep249 import Connection

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
            msg = str(e)

            logger.debug("Upsolver error : {}".format(msg))

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
            handle = Connection.connect(
                 api_url = connection.credentials.api_url,
                 token = connection.credentials.token)
            connection.state = "open"
            connection.handle = handle
        except Exception as e:
            print('handle error')
            print(str(e))
        return connection
        #pass

    @classmethod
    def get_response(cls,cursor):
        """
        Gets a cursor object and returns adapter-specific information
        about the last executed command generally a AdapterResponse ojbect
        that has items such as code, rows_affected,etc. can also just be a string ex. "OK"
        if your cursor does not offer rich metadata.
        """
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
        pass
