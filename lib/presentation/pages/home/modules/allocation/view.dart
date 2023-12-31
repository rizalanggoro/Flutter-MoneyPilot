import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:money_pilot/core/route/config.dart';
import 'package:money_pilot/core/route/params/allocation_detail.dart';
import 'package:money_pilot/presentation/bloc/set_allocation/cubit.dart';

part 'cubit.dart';
part 'state.dart';

class HomeAlloaction extends StatelessWidget {
  const HomeAlloaction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<CubitSetAllocation, StateSetAllocation>(
              bloc: context.read<CubitSetAllocation>(),
              builder: (context, state) {
                final setAllocations = state.setAllocations;

                return ListView.builder(
                  itemBuilder: (context, index) {
                    final setAllocation = setAllocations[index];
                    return ListTile(
                      title: Text(setAllocation.title),
                      subtitle: Text(
                        '${setAllocation.setAllocations.length} kategori',
                      ),
                      trailing: Text(
                        NumberFormat.currency(
                          locale: 'id',
                        ).format(
                          setAllocation.maxAmount,
                        ),
                      ),
                      onTap: () => context.push(
                        Routes.allocationDetail,
                        extra: RouteParamAllocationDetail(
                          setAllocation: setAllocation,
                        ),
                      ),
                    );
                  },
                  shrinkWrap: true,
                  itemCount: setAllocations.length,
                  physics: const NeverScrollableScrollPhysics(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  get _appbar => AppBar(title: const Text('Alokasi'));
}
