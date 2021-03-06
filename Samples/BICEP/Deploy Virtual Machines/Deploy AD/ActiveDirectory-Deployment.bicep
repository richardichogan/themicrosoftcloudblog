//***********************************************************************
// Script           : DeployVMs.bicep
// Author           : Richard Hogan
// Created          : 06-08-2021
// ***********************************************************************
// <copyright file="DEployVMs.bicep" company="N/A">
// THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
// KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
// </copyright>
// <summary></summary>
// <auto-generated/>
// ***********************************************************************

param VMName string
param VNetID string

resource VM_PublicIP 'Microsoft.Network/publicIPAddresses@2021-02-01' ={
  name:'ADPublicIP'
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

resource NIC_VM_Static 'Microsoft.Network/networkInterfaces@2020-08-01' = {
  name: 'AD01NIC_Static'
  location: 'uksouth'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          publicIPAddress: {
            id: VM_PublicIP.id
          }
          privateIPAllocationMethod: 'Static'
          privateIPAddress: '10.0.0.5'
          subnet: {
            id: '${VNetID}/subnets/${'default'}'
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

resource NIC_VM_Dynamic 'Microsoft.Network/networkInterfaces@2020-08-01' = {
  name: 'AD01NIC_Dynamic'
  location: 'uksouth'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: '${VNetID}/subnets/${'default'}'
          }
          primary: false
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
      vmSize: 'Standard_D3_v2'
      }
      storageProfile: {
        osDisk: {
          createOption: 'FromImage'
          osType: 'Windows'
          managedDisk: {
            storageAccountType: 'Standard_LRS'
          }
        }
        imageReference: {
          publisher: 'MicrosoftWindowsServer'
          offer: 'WindowsServer'
          sku: '2019-datacenter'
          version: '17763.1518.2010132039'
        }
      }
      osProfile: {
        computerName: 'RHAD01'
        adminUsername: 'vmAdministrator'
        adminPassword: 'Myd0g1sBRadley01'
      }
      networkProfile: {
        networkInterfaces: [
          {
            properties: { 
              primary: true
            }
            id: NIC_VM_Dynamic.id
          }
          {
            properties: { 
              primary: false
            }
            id: NIC_VM_Static.id
          }
        ]
      }
  }
}
