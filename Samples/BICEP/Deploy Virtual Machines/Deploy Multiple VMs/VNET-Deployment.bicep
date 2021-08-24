param VNetName string
param Location string
param SubNetName string

module VNet 'modules/VNet.bicep' = {
  name: 'appService'
  params: {
    Location: Location
    VNetName: VNetName
    SubNetName: SubNetName
  }
}
