param VNetName string
param Location string
param SubNetName string

resource VNet_Default 'Microsoft.Network/virtualNetworks@2020-08-01' = {
  name: VNetName
  location: Location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/24'
      ]
    }
    subnets: [
      {
        name: SubNetName
        properties: {
          addressPrefix: '10.0.0.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

output VNetId string = VNet_Default.id
