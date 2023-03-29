Connection_options = {
  "s3": {
        "aws_role": {"type": "text", "editable": True, "optional": True},
        "external_id": {"type": "text", "editable": True, "optional": True},
        "aws_access_key_id": {"type": "text", "editable": True, "optional": True},
        "aws_secret_access_key_id": {"type": "text", "editable": True, "optional": True},
        "path_display_filter": {"type": "text", "editable": True, "optional": True},
        "path_display_filters": {"type": "list", "editable": True, "optional": True},
        "read_only": {"type": "boolean", "editable": True, "optional": True},
        "encryption_kms_key": {"type": "text", "editable": True, "optional": True},
        "encryption_customer_kms_key": {"type": "text", "editable": True, "optional": True},
        "comment": {"type": "text", "editable": True, "optional": True}
  },
    "kafka": {
        "host": {"type": "text", "editable": False, "optional": False},
        "hosts": {"type": "list", "editable": False, "optional": False},
        "consumer_properties": {"type": "text", "editable": True, "optional": True},
        "version": {"type": "value", "editable": False, "optional": True},
        "require_static_ip": {"type": "boolean", "editable": True, "optional": True},
        "ssl": {"type": "boolean", "editable": True, "optional": True},
        "topic_display_filter": {"type": "text", "editable": True, "optional": True},
        "comment": {"type": "text", "editable": True, "optional": True}
    }
}
