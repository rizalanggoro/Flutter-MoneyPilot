import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:money_pilot/core/route/params/category_select.dart';
import 'package:money_pilot/domain/models/category.dart';
import 'package:money_pilot/domain/usecases/filter_category_by_type.dart';
import 'package:money_pilot/presentation/bloc/category/cubit.dart';

part 'cubit.dart';

class PageCategorySelect extends StatefulWidget {
  final Object? extra;
  const PageCategorySelect({
    super.key,
    this.extra,
  });

  @override
  State<PageCategorySelect> createState() => _PageCategorySelectState();
}

class _PageCategorySelectState extends State<PageCategorySelect> {
  List<_TabItem> _tabItems = [];
  bool _isExpenseOnly = false;
  Category? _category;
  int _initialIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.extra != null && widget.extra is RouteParamCategorySelect) {
      final params = widget.extra as RouteParamCategorySelect;
      _isExpenseOnly = params.isExpenseOnly ?? false;
      _category = params.category;

      if (!_isExpenseOnly) {
        _initialIndex = _category?.type.index ?? 0;
      }
    }

    _tabItems = [
      if (!_isExpenseOnly)
        const _TabItem(
          title: 'Pemasukan',
          categoryType: CategoryType.income,
        ),
      const _TabItem(
        title: 'Pengeluaran',
        categoryType: CategoryType.expense,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: _initialIndex,
      length: _tabItems.length,
      child: Scaffold(
        appBar: _appbar,
        body: _content,
      ),
    );
  }

  get _appbar => AppBar(
        title: const Text('Pilih kategori'),
        bottom: TabBar(
          tabs: _tabItems
              .map(
                (e) => Tab(
                  child: Text(e.title),
                ),
              )
              .toList(),
        ),
      );

  get _content => TabBarView(
        children: _tabItems
            .map((e) => BlocBuilder<CategoryCubit, CategoryState>(
                  bloc: context.read<CategoryCubit>(),
                  builder: (context, state) {
                    var groupValue = _category?.key ?? -1;

                    final categories =
                        context.read<CategorySelectCubit>().filterByType(
                              categories: state.categories,
                              categoryType: e.categoryType,
                            );

                    return ListView.builder(
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return RadioListTile<int>(
                          groupValue: groupValue,
                          value: category.key ?? -1,
                          title: Text(category.name),
                          onChanged: (value) => context.pop(
                            category,
                          ),
                        );
                      },
                      itemCount: categories.length,
                      shrinkWrap: true,
                    );
                  },
                ))
            .toList(),
      );
}

class _TabItem {
  final String title;
  final CategoryType categoryType;
  const _TabItem({
    required this.title,
    required this.categoryType,
  });
}
