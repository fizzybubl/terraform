import boto3


def init_client(aws_service: str = "ec2", profile_name: str = "admin"):
    boto3.setup_default_session(profile_name=profile_name)
    return boto3.client(aws_service)



class AWSSnapshotsClient:

    def __init__(self, client):
        self._client = client

    def list_snapshots(self, filters: list[dict]):
        return self._client.describe_snapshots(Filters=filters)

    def delete_snapshot(self, snapshot_id: str):
        self._client.delete_snapshot(snapshot_id)


class K8sSnapshotsClient:
    def __init__(self, client):
        self._client = client

    def list_snapshots(self, filters: list[dict]):
        return self._client.describe_snapshots(filters)

    def list_snapshot_contents(self):
        ...

    def delete_snapshot(self, snapshot_id: str):
        self._client.delete_snapshot(snapshot_id)


if __name__ == "__main__":
    aws_client = AWSSnapshotsClient(init_client())
    snapshots = aws_client.list_snapshots([
        {
            'Name': 'tag:Project',
            'Values': [
                'tag-value',
            ]
        },
    ])

    print(snapshots)