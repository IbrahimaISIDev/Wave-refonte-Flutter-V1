import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:wave_app/bloc/transfer/transfer_bloc.dart';
import 'package:wave_app/bloc/transfer/transfer_event.dart' as transfer_event;
import 'package:wave_app/bloc/transfer/transfer_history_bloc.dart' as transfer_history_bloc;
import 'package:wave_app/bloc/transfer/transfer_state.dart';

class TransferHistoryScreen extends StatefulWidget {
  const TransferHistoryScreen({super.key});

  @override
  State<TransferHistoryScreen> createState() => _TransferHistoryScreenState();
}

class _TransferHistoryScreenState extends State<TransferHistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TransferBloc>().add(transfer_event.LoadTransferHistoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Historique des transferts',
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocBuilder<TransferBloc, TransferState>(
        builder: (context, state) {
          if (state is TransferLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is transfer_history_bloc.TransferHistoryLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.transfers.length,
              itemBuilder: (context, index) {
                final transfer = state.transfers[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${transfer.amount.toStringAsFixed(2)} €',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            _buildStatusChip(transfer.status),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Destinataire: ${transfer.recipient.phone}',
                          style: GoogleFonts.poppins(
                            color: Colors.black54,
                          ),
                        ),
                        if (transfer.createdAt != null)
                          Text(
                            'Date: ${_formatDate(transfer.createdAt!)}',
                            style: GoogleFonts.poppins(
                              color: Colors.black54,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is TransferFailure) {
            return Center(
              child: Text(
                state.message ?? 'Une erreur est survenue',
                style: GoogleFonts.poppins(color: Colors.red),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildStatusChip(String? status) {
    Color color;
    String displayStatus = status ?? 'Unknown';
    switch (displayStatus.toLowerCase()) {
      case 'completed':
        color = Colors.green;
        break;
      case 'pending':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        displayStatus,
        style: GoogleFonts.poppins(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }
}
