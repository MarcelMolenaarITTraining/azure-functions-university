func init --worker-runtime dotnet --force

dotnet build

func new --template "HTTP trigger" --name "Echo"
func new --template "Timer trigger" --name "Recurring"
func new --template "HTTP trigger" --name "GetSettingInfo"

func extensions install --package Microsoft.Azure.WebJobs.Extensions.Storage --version 4.0.4

dotnet build
