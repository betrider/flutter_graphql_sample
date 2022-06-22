
import 'package:flutter/services.dart';
import 'package:flutter_graphql_sample/model/Country.dart';
import 'package:flutter_graphql_sample/server/GraphQLConfig.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

Future<String> getCountQuery() async {
  return await rootBundle.loadString('assets/countryQuery.gql');
}

class ApiClients {
  ///Example on how to implement query to get country
  Future<Country> getCountry(String code) async {
    Country country = Country();
    try {
      String countQuery = await getCountQuery();
      String data = countQuery.replaceAll('code','').replaceAll('     \n','');
      print('###');
      print(data);

      ///initializing GraphQLConfig
      GraphQLConfig graphQLConfiguration = GraphQLConfig();
      GraphQLClient _client = graphQLConfiguration.clientToQuery();
      QueryResult result = await _client.query(
        QueryOptions(document: gql(countQuery), variables: {"input": "$code"}),
      );

      if (result.hasException) {
        print(result.exception?.graphqlErrors[0].message);
      } else if (result.data != null) {
        country = Country.fromJson(result.data!["country"]);

        return country;
      }
    } catch (e) {
      print(e);
      return country;
    }
    return country;
  }

  ///THIS IS A SAMPLE FOR MAKING MUTABLE REQUEST
  ///login
  static String login(String email, String password) {
    return '''
            mutation{
              login(data: {
                input:"$email",
                password: "$password"
              }){
                token
                  user{
                  _id
                  email
                  phonenumber
                  referralCode
                  username
                  emailVerified
                }
              }
            }
        ''';
  }

  ///Example on how to implement mutation
  Future<String> Login(String email, password) async {
    try {
      ///initializing GraphQLConfig
      GraphQLConfig graphQLConfiguration = GraphQLConfig();
      GraphQLClient _client = graphQLConfiguration.clientToQuery();
      QueryResult result = await _client.mutate(
        MutationOptions(
          document: gql(login(email, password)), // this
        ),
      );
      if (result.hasException) {
        print(result.exception?.graphqlErrors[0]?.message);
      } else if (result.data != null) {
        //  parse your response here and return
        // var data = User.fromJson(result.data["register"]);
      }

      return "";
    } catch (e) {
      print(e);
      return "";
    }
  }
}
