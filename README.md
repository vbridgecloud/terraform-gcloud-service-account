# Terraform Google Cloud Platform Service Account

Easily create a Service Account with certain IAM Roles applied

## Basic Usage

```hcl
# Create a Service Account named `cloud-function` and give it the `roles/cloudfunctions.invoker` IAM role
module "terraform-gcloud-service-account" {
  source     = "github.com/vbridgebvba/terraform-gcloud-service-account"
  account_id = 'cloud-function'
  roles      = [
    "roles/cloudfunctions.invoker"
  ]
}
```

The module `terraform-gcloud-http-cloud-function` will:

1. Create the Service Account
2. Apply the IAM roles

## Variables

### Required Variables

- `account_id`: The `account_id` that is used to generate the service account email address and a stable unique id. It is unique within a project, must be 6-30 characters long, and match the regular expression [a-z]([-a-z0-9]*[a-z0-9]) to comply with RFC1035. Changing this forces a new service account to be created.
- `roles`: Array of [Cloud IAM Roles](https://cloud.google.com/iam/docs/understanding-roles) to add to the Service Account

### Optional Variables and their defaults

- `project`: _(the provider project configuration)_
- `display_name`: `"Managed by Terraform"`

## Outputs

- `sa`: The Service Account, of type [`google_service_account`](https://www.terraform.io/docs/providers/google/d/datasource_google_service_account.html).
  - `email`: The e-mail address of the service account.
  - `unique_id`: The unique id of the service account.
  - `name`: The fully-qualified name of the service account.
  - `display_name`: The display name for the service account.

## FAQ

### IAM Roles are not applied, I'm getting back an HTTP 403

#### Problem

You get back an error when running `terraform apply`:

```
returned error: Error applying IAM policy for project "my-project": Error setting IAM policy for project "my-project":
googleapi: Error 403: The caller does not have permission, forbidden
```

#### Cause

The account that's running `terraform apply` has insufficient privileges.

#### Solution

Give the invoker's account the "Project IAM Admin" (`roles/resourcemanager.projectIamAdmin`) using [the IAM Permissions for your project view](https://console.cloud.google.com/iam-admin/iam)

### IAM Roles are not applied, I'm getting back an HTTP 400

#### Problem

You get back an `INVALID_ARGUMENT` error when running `terraform apply`:

```
returned error: Error applying IAM policy for project "my-project": Error setting IAM policy for project "my-project":
googleapi: Error 400: Request contains an invalid argument., badRequest
```

#### Cause

There's [a bug in Terraform](https://github.com/terraform-providers/terraform-provider-google/issues/4276) which reformats e-mail addresses to lowercase. If you have a Service Account or User with an uppercase character in their e-mail address (such as `Firstname.Lastname@domain.tld`, GCP's Resource Manager won't be able to apply the policies as Terraform sends out the all-lowercase `firstname.lastname@domain.tld`.

#### Solution

Make sure that all members (including pre-existing ones) are added with a lowercase e-mail addresses. Use [the IAM Permissions for your project view](https://console.cloud.google.com/iam-admin/iam) or `gcloud projects get-iam-policy PROJECT-ID` to verify.

## License

`terraform-gcloud-service-account` is released under the MIT License. See the enclosed [`LICENSE` file](LICENSE) for details.