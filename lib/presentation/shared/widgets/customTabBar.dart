// import 'package:flutter/material.dart';
//
// class TabItem extends StatelessWidget {
//   final String title;
//   final int count;
//
//   const TabItem({
//     super.key,
//     required this.title,
//     required this.count,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Tab(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             title,
//             overflow: TextOverflow.ellipsis,
//           ),
//           count > 0
//               ? Container(
//             margin: const EdgeInsetsDirectional.only(start: 5),
//             padding: const EdgeInsets.all(3),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade200,
//               shape: BoxShape.circle,
//             ),
//             child: Center(
//               child: Text(
//                 count > 9 ? "9+" : count.toString(),
//                 style: const TextStyle(
//                   color: Colors.black54,
//                   fontSize: 10,
//                 ),
//               ),
//             ),
//           )
//               : const SizedBox(width: 0, height: 0),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TabItem extends StatelessWidget {
  final String title;

  const TabItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        title,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.spaceGrotesk(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        //style: AppTextStyles.textCaption1,
      ),
    );
  }
}
