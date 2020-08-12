# api-portal-exercise

API's application using infrastructure provisioning and application deployment on Azure cloud platform.

## Tools

- Packer 1.6.1
- Chef Workstation 20.8.111
- Docker 19.03.12
- Terraform 0.12.29
- azure-cli 2.10.0
- Node.js 12.16.3
- PostgreSQL 9.6

## Execution

On Azure Portal, create resource group named `api-portal-images`

Open `start.sh` and fill environment variables with Azure credentials properly.

Give execution permissions to script:

```
chmod +x start.sh
```

Run script:

```
./start.sh
```

Once finished, use IP printed in `api-vm-ip` output and port `3010` to execute APIs.

```
api-vm-ip = <ip-to-execute-api>
```

## Objective

Build environment on Azure cloud service, consisting on network resources and two VMs:

1. **Application**, as a Node.js application running on Docker.
2. **Database**, using PostgreSQL DBMS.

Network configuration must be provided to give connectivity between VMs.

## Steps Involved in Building

1. Application creation with Docker configuration.
2. Set Chef image recipes to automate VM installation (*).
3. VM images building (Ubuntu Server 18.04-LTS) using Packer scripts.
4. Terraform script elaboration to provision infrastructure.
5. Azure account activation to get credentials needed to execute Terraform script.

(*) Applications configured with Chef:

- `apt-get` (updating Ubuntu modules)
- Docker (installation)
- PostgreSQL (installation)
- API (application installation and running)

## APIs

| Method | Path | Description |
| ------ | ---- | ----------- |
| GET | `/people` | Array with all people. |
| GET | `/people/:nationalId` | Get person by national Id. |
| POST | `/people + json` | Person creation using JSON payload. |
| PUT | `/people/:id + json` | Update JSON fields of person `id`. |
| DELETE | `/people/:id` | Delete a person by national Id. |

Payload is a JSON document as follows:

```json
{
    "nationalId": "12345678-9",
    "name": "Hari",
    "lastName": "Seldon",
    "age": 45,
    "originPlanet": "Helicon",
    "pictureUrl": "https://your.picture.com/hari-seldon"
}
```
