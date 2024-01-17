
import '../models/cities_model.dart';
import '../models/country_state_model.dart' as cs_model;
import '../repositories/country_state_city_repo.dart';
import 'package:flutter/material.dart';

class CountryStateDD extends StatefulWidget {
  const CountryStateDD({super.key});

  @override
  State<CountryStateDD> createState() => _CountryStateDDState();
}

class _CountryStateDDState extends State<CountryStateDD> {
  final CountryStateCityRepo _countryStateCityRepo = CountryStateCityRepo();

  List<String> states = [];
  List<String> cities = [];
  bool isLoading=true;
  cs_model.CountryStateModel countryStateModel =
      cs_model.CountryStateModel(error: false, msg: '', data: []);

  CitiesModel citiesModel = CitiesModel(error: false, msg: '', data: []);

  String selectedCountry = 'India';
  String selectedState = 'Select State';
  String selectedCity = 'Select City';
  bool isDataLoaded = false;

  String finalTextToBeDisplayed = '';


  getStatesOfIndia() async {
    //
    countryStateModel = await _countryStateCityRepo.getCountriesStates();
    states.add('Select State');
    cities.add('Select City');
    for (var element in countryStateModel.data) {
      if (element.name == 'India') {
        for (var state in element.states) {
          states.add(state.name);
        }
        break;
      }
    }
    isLoading = false;
    setState(() {});
    //
  }

  getCitiesOfState() async {
    //
    isDataLoaded = false;
    citiesModel = await _countryStateCityRepo.getCities(
        country: selectedCountry, state: selectedState);
    setState(() {
      resetCities();
    });
    for (var city in citiesModel.data) {
      cities.add(city);
    }
    isDataLoaded = true;
    setState(() {});
    //
  }


  resetCities() {
    cities = [];
    cities.add('Select City');
    selectedCity = 'Select City';
    finalTextToBeDisplayed = '';
  }

  resetStates() {
    states = [];
    states.add('Select State');
    selectedState = 'Select State';
    finalTextToBeDisplayed = '';
  }

  @override
  void initState() {
    getStatesOfIndia();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Country State City'),
        centerTitle: true,
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    DropdownButton(
                        isExpanded: true,
                        value: selectedState,
                        items: states
                            .map((String state) => DropdownMenuItem(
                                value: state, child: Text(state)))
                            .toList(),
                        onChanged: (selectedValue) {
                          //
                          setState(() {
                            selectedState = selectedValue!;
                          });
                          if (selectedState != 'Select State') {
                            getCitiesOfState();
                          }
                          //
                        }),
                    const SizedBox(height: 20),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: selectedCity,
                      items: selectedState != 'Select State' && isDataLoaded
                          ? cities.map((String city) => DropdownMenuItem(value: city, child: Text(city))).toList()
                          : [DropdownMenuItem(value: selectedCity, child: Text(selectedCity))], // Display the selected city or a hint
                      onChanged: selectedState != 'Select State' && isDataLoaded
                          ? (selectedValue) {
                        setState(() {
                          selectedCity = selectedValue!;
                          if (selectedCity != 'Select City') {
                            finalTextToBeDisplayed = "Country: $selectedCountry\nState: $selectedState\nCity: $selectedCity";
                          }
                        });
                      }
                          : null, // Set to null to disable dropdown
                      hint: Text('Select City'), // Optional: show hint when dropdown is enabled but no city is selected yet
                    ),

                    Text(
                      finalTextToBeDisplayed,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ],
                )),
      ),
    );
  }
}
