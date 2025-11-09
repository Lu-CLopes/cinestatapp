// import 'package:app_mobile_clinica_medica/features/shared/widgets/circle_icon.dart';
// import 'package:flutter/material.dart';

// class SearchBarWidget extends StatefulWidget {
//   final int uid;
//   const SearchBarWidget({super.key, required this.uid});

//   @override
//   _SearchBarWidgetState createState() => _SearchBarWidgetState();
// }

// class _SearchBarWidgetState extends State<SearchBarWidget> {
//   int appliedFilters = 0;

//   @override
//   void initState() {
//     super.initState();

//     // Check filters in singleton and update conter
//     final filtros = SelectedFilter();
//     int quantity = 0;
//     if (filtros.specialty != null && filtros.specialty!.isNotEmpty) quantity++;
//     if (filtros.clinic != null && filtros.clinic!.isNotEmpty) quantity++;
//     if (filtros.location != null && filtros.location!.isNotEmpty) quantity++;
//     if (filtros.doctorName != null && filtros.doctorName!.isNotEmpty) {
//       quantity++;
//     }

//     setState(() {
//       appliedFilters = quantity;
//     });
//   }

//   // Function to open the filter page and get the selected filters
//   void _openFilters() async {
//     final result = await showModalBottomSheet<Map<String, String?>>(
//       context: context,
//       isScrollControlled: true,
//       builder: (_) => FilterPage(uid: widget.uid),
//     );

//     // Update quantity of the filters apply with singleton
//     final filtros = SelectedFilter();
//     int quantity = 0;
//     if (filtros.specialty != null && filtros.specialty!.isNotEmpty) quantity++;
//     if (filtros.clinic != null && filtros.clinic!.isNotEmpty) quantity++;
//     if (filtros.location != null && filtros.location!.isNotEmpty) quantity++;
//     if (filtros.doctorName != null && filtros.doctorName!.isNotEmpty)
//       quantity++;

//     // Update the state with the number of applied filters
//     setState(() {
//       appliedFilters = quantity;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // Container with text field and filter icon
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(30),
//       ),
//       child: Row(
//         children: [
//             // Lista de médicos
//             Expanded(
//             child: GridView.builder(
//             // Cria uma grade de médicos
//             // com espaçamento entre os itens
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 12,
//               mainAxisSpacing: 20,
//               childAspectRatio: 0.65,
//             ),
//             // Exibe o widgets com a foto e a informação do médico
//             // de acordo com a quantidade de médicos na lista
//             itemCount: _filmes.length,
//             itemBuilder: (context, index) {
//               final doctor = _filmes[index];
//               return FilmesCard(
//                 movieName: doctor.name,
//                 movie: 'Especialidade: ${doctor.specialty}',
//                 imageUrl: 'lib/images/default_profile.jpg',
//                 CRM: doctor.crm,
//                 uid: widget.uid,
//               );
//             },
//           ),
//           IconButton(
//             // Icon to open the filter page
//             icon: const CircleIcon(
//               icon: Icons.tune,
//               color: Color(0xFF0089FF),
//               backgroundColor: Colors.white,
//             ),
//             onPressed: _openFilters,
//           ),
//         ],
//       ),
//     );
//   }
// }
