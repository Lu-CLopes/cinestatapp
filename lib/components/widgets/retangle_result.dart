// import 'package:app_mobile_clinica_medica/features/shared/widgets/header_close_back.dart';
// import 'package:flutter/material.dart';
// import 'package:app_mobile_clinica_medica/features/dashboard/view/widgets/search_bar.dart';
// import 'rectangle.dart';

// class ResultRetangle extends StatelessWidget {
//   final double width;
//   final double height;
//   final bool returnHome;
//   final int uid;

//   const ResultRetangle({
//     super.key,
//     required this.width,
//     required this.height,
//     this.returnHome = false,
//     required this.uid,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         // Retângulo com gradiente de fundo
//         GradientRectangle(width: width, height: height),

//         // Botão de voltar
//         Positioned(
//           top: 16,
//           left: 16,
//           right: 16,
//           child: CustomHeader(
//             isCloseButton: false,
//             iconColor: Colors.white,
//             returnHome: returnHome,
//           ),
//         ),

//         // Conteúdo principal: Título + Barra de busca
//         Padding(
//           padding: const EdgeInsets.only(
//             top: 90, // mais distante do header, mais perto da searchbar
//             left: 20,
//             right: 20,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(
//                 width: double.infinity,
//                 child: Text(
//                   'Encontrando o seu médico',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 25,
//                     fontFamily: 'Nunito',
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               SearchBarWidget(uid: uid),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
