import uuid


class S3Interactor:

    def __init__(self, s3, bucket_name: str):
        self.bucket_name = bucket_name
        self.s3 = s3

    def upload_to_s3(self, bytes: str, key: str):
        self.s3.put_object(
            Bucket=self.bucket_name,
            Key=key,
            Body=bytes,
            ContentType='image/gif',
        )

    def generate_presigned_url(self, key: str) -> str:
        url = self.s3.generate_presigned_url(
            'get_object',
            Params={
                'Bucket': self.bucket_name,
                'Key': key
            },
            ExpiresIn=1000
        )
        return url

    def generate_unique_key(self) -> str:
        image_id = str(uuid.uuid4())
        return f'temp/{image_id}'