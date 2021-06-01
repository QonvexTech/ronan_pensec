import 'package:ronan_pensec/global/region_raw_data.dart';

class RawRegionController{
  RawRegionController._singleton();
  static final RawRegionController _instance = RawRegionController._singleton();
  static RawRegionController get instance => _instance;
  static final RegionRawData _regionRawData = RegionRawData.instance;
  RegionRawData get regionData => _regionRawData;
}