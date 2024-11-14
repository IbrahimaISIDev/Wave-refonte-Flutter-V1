// transfer_history_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wave_app/data/models/transfer_model.dart';
import 'package:wave_app/data/repositories/transfer_repository.dart';

// Événements
abstract class TransferHistoryEvent {}

class LoadTransferHistoryEvent extends TransferHistoryEvent {}

// États
abstract class TransferHistoryState {}

class TransferHistoryInitial extends TransferHistoryState {}
class TransferHistoryLoading extends TransferHistoryState {}
class TransferHistoryLoaded extends TransferHistoryState {
  final List<TransferHistory> transfers;
  TransferHistoryLoaded(this.transfers);
}
class TransferHistoryError extends TransferHistoryState {
  final String message;
  TransferHistoryError(this.message);
}

class TransferHistoryBloc extends Bloc<TransferHistoryEvent, TransferHistoryState> {
  final TransferRepository transferRepository;

  TransferHistoryBloc({required this.transferRepository}) : super(TransferHistoryInitial()) {
    // Enregistrement du gestionnaire d'événements ici
    on<LoadTransferHistoryEvent>((event, emit) async {
      try {
        // Émettre l'état de chargement
        emit(TransferHistoryLoading());
        // Récupérer les transferts depuis le repository
        final transfers = await transferRepository.getTransferHistory();
        // Émettre l'état chargé avec les données
        emit(TransferHistoryLoaded(transfers.cast<TransferHistory>()));
      } catch (e) {
        // En cas d'erreur, émettre l'état d'erreur
        emit(TransferHistoryError(e.toString()));
      }
    });
  }
}

// // Dans votre transfer_history_screen.dart
// class TransferHistoryScreen extends StatefulWidget {
//   @override
//   _TransferHistoryScreenState createState() => _TransferHistoryScreenState();
// }

// class _TransferHistoryScreenState extends State<TransferHistoryScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // S'assurer que le Bloc est correctement fourni dans l'arbre des widgets
//     context.read<TransferHistoryBloc>().add(LoadTransferHistoryEvent());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<TransferHistoryBloc, TransferHistoryState>(
//       builder: (context, state) {
//         if (state is TransferHistoryLoading) {
//           return Center(child: CircularProgressIndicator());
//         } else if (state is TransferHistoryLoaded) {
//           return ListView.builder(
//             itemCount: state.transfers.length,
//             itemBuilder: (context, index) {
//               final transfer = state.transfers[index];
//               return ListTile(
//                 // Afficher les détails du transfert
//               );
//             },
//           );
//         } else if (state is TransferHistoryError) {
//           return Center(child: Text('Erreur: ${state.message}'));
//         }
//         return Container();
//       },
//     );
//   }
// }