import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'pokemon_api.g.dart';

@RestApi(baseUrl: "https://pokeapi.co/api/v2/")
abstract class PokemonApi {
  factory PokemonApi(Dio dio, {String baseUrl}) = _PokemonApi;

  @GET("/pokemon/{id}")
  Future<String> getPokemon(@Path("id") int id);

  @GET("/pokemon")
  Future<String> getPokemonList(@Query("offset") int offset, @Query("limit") int limit);
}
