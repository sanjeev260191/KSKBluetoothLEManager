KSKBluetoothLEManager
=====================

KSKBluetoothLEManager

KSKBluetoothLEManager is iOS application to intiate a peripheral manager using Blutooth Low Energy devices(Bluetooth 4.0).
Peripheral manager is intiated with following ids.
ServiceUUID = ECE1A9DC-3027-4871-96E6-9B390A1FB6FA
CharacteristicUUID = F6F49F52-F8EC-4D2F-9AF0-D5B257678923
Data being broadcasted is a string "abcd" currently. Can be modified.

Also you can find any Bluetooth devices broadcasting data around the device using the Central Manager. The device gets registered to the broadcaster and receives updates.
