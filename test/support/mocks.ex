# Mox
Mox.defmock(BabygeniusWeb.AmazonDeviceService.Mock, for: BabygeniusWeb.AmazonDeviceService)

Mox.defmock(
  Babygenius.Locality.FetchZipcodeFromDeviceApi.Mock,
  for: Babygenius.Locality.FetchZipcodeFromDeviceApi
)

Mox.defmock(
  Babygenius.Locality.ZipcodeTimezoneService.Mock,
  for: Babygenius.Locality.ZipcodeTimezoneService
)

Mox.defmock(Babygenius.Locality.Mock, for: Babygenius.Locality.Behaviour)
Mox.defmock(Babygenius.BabyLife.Mock, for: Babygenius.BabyLife.Behaviour)