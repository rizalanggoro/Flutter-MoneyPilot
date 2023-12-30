import 'package:dartz/dartz.dart';
import 'package:money_pilot/core/failure/failure.dart';
import 'package:money_pilot/data/providers/local.dart';
import 'package:money_pilot/domain/models/set_allocation.dart';
import 'package:money_pilot/domain/models/set_allocation_item.dart';
import 'package:money_pilot/domain/repositories/set_allocation.dart';

class RepositorySetAllocationImpl implements RepositorySetAllocation {
  final ProviderLocal _providerLocal;
  final _databaseName = 'set-allocations';

  RepositorySetAllocationImpl({
    required ProviderLocal providerLocal,
  }) : _providerLocal = providerLocal;

  @override
  Future<Either<Failure, int>> create({
    required SetAllocation setAllocation,
  }) async {
    final putResult = await _providerLocal.add(
      name: _databaseName,
      data: setAllocation.toJson(),
    );
    return putResult.fold(
      (l) => Left(
        Failure(
          message: 'Gagal menambahkan set alokasi! [${l.message}]',
        ),
      ),
      (r) => Right(r),
    );
  }

  @override
  Future<Either<Failure, List<SetAllocation>>> read() async {
    final readResult = await _providerLocal.readEntries(
      name: _databaseName,
    );
    return readResult.fold(
      (l) => Left(
        Failure(
          message: 'Gagal membaca set alokasi! [${l.message}]',
        ),
      ),
      (r) {
        final result = r.map(
          (e) {
            var setAllocation = SetAllocation.fromJson({
              ...Map<String, dynamic>.from(e),
              'setAllocations': [],
            });

            return setAllocation.copyWith(
              setAllocations: List.of(e['setAllocations'])
                  .map((e) => SetAllocationItem.fromJson(
                        Map<String, dynamic>.from(e),
                      ))
                  .toList(),
            );
          },
        ).toList();

        return Right(result);
      },
    );
  }

  @override
  Future<Either<Failure, void>> delete({
    required int key,
  }) async {
    final deleteResult = await _providerLocal.delete(
      name: _databaseName,
      key: key,
    );
    return deleteResult.fold(
      (l) => Left(
        Failure(
          message: 'Gagal menghapus set alokasi! [${l.message}]',
        ),
      ),
      (r) => const Right(null),
    );
  }
}
