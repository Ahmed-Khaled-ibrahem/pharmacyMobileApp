import 'package:pharmacyapp/models/drug_model.dart';
import 'package:supabase/supabase.dart';

const String _subBaseUrl = "https://ulnzanczkctnwgxaqxyt.supabase.co";
const String _subBaseAnnon =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTY0MzYxMDU1OCwiZXhwIjoxOTU5MTg2NTU4fQ.I65qtiIhDVVpy4Fi7zOtof8moeV9sO7n4tAjhCk-3rc";

class SubBaseHelper {
  final _supBase = SupabaseClient(_subBaseUrl, _subBaseAnnon);

  Future<List<Drug>> getDrugs({String? subName, int? id}) async {
    PostgrestResponse res;

    if (subName != null) {
      res = await _supBase
          .from('drugs')
          .select()
          .like("name", "%$subName%")
          .execute();
    } else {
      res = await _supBase.from('drugs').select().match({"id": id}).execute();
    }

    if (res.error != null) {
      return Future.error(res.error!.message);
    } else {
      List<dynamic> data = res.data;
      List<Drug> drugsData = data.map((e) => Drug(drugData: e)).toList();
      return drugsData;
    }
  }
}
