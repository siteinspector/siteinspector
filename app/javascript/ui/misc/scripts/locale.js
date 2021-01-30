import locale from 'view3/src/locale'
import en from 'view3/src/locale/lang/en-US'

locale.use(Object.assign(en, {
  marked_as_resolved: 'Marked as Resolved',
  marked_as_pending: 'Marked as Pending',
  marked_as_excluded: 'Marked as Excluded'
}))

export default locale
