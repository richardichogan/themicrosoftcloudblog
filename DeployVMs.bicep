param VMName string

resource VNet_Default 'Microsoft.Network/virtualNetworks@2020-08-01' = {
  name: 'VMVNet01'
  location: 'uksouth'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/24'
      ]
    }
    subnets: [
      {
        name: 'VMSubnet'
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

resource VM_PublicIP 'Microsoft.Network/publicIPAddresses@2021-02-01' ={
  name:'VMPublicIPAddress'
  location: 'uksouth'
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Dynamic'
  }
}

resource NIC_VM 'Microsoft.Network/networkInterfaces@2020-08-01' = {
  name: 'rhnic01'
  location: 'uksouth'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          publicIPAddress: {
            id: VM_PublicIP.id
          }
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: '${VNet_Default.id}/subnets/${'vmSubnet'}'
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
  }
}

resource VirtualMachine 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: VMName
  location: 'uksouth'
  properties:{
    hardwareProfile: {
      vmSize:'Standard_D2s_v3'
      }
      storageProfile: {
        osDisk: {
          createOption: 'FromImage'
          osType: 'Windows'
          managedDisk: {
            storageAccountType: 'StandardSSD_LRS'
          }
        }
        imageReference: {
          publisher: 'MicrosoftWindowsDesktop'
          offer: 'Windows-10'
          sku: '19H1-ent'
          version: '18362.1198.2011031735'
        }
      }
      osProfile: {
        computerName: 'testcomputer'
        adminUsername: 'vmAdministrator'
        adminPassword: 'Adm1nP@55w0rd'
      }
      networkProfile: {
        networkInterfaces: [
          {
            id: NIC_VM.id
          }
        ]
      }
  }
}
