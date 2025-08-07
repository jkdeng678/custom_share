package com.example.custom_share

import android.app.Activity
import android.content.Context
import android.content.Intent
import androidx.core.content.FileProvider
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File

class CustomSharePlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
  private lateinit var channel: MethodChannel
  private lateinit var applicationContext: Context
  private var activity: Activity? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "custom_share")
    channel.setMethodCallHandler(this)
    applicationContext = flutterPluginBinding.applicationContext
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivity() {
    activity = null
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "shareText" -> shareText(call, result)
      "shareFiles" -> shareFiles(call, result)
      else -> result.notImplemented()
    }
  }

  private fun shareText(call: MethodCall, result: Result) {
    val text = call.argument<String>("text")
    if (text.isNullOrEmpty()) {
      result.error("INVALID_TEXT", "Text cannot be null or empty", null)
      return
    }

    val shareIntent = Intent(Intent.ACTION_SEND).apply {
      type = "text/plain"
      putExtra(Intent.EXTRA_TEXT, text)
      if (activity == null) {
        addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
      }
    }
    val chooserIntent = Intent.createChooser(shareIntent, "Share via")
    try {
      val context = activity ?: applicationContext
      context.startActivity(chooserIntent)
      result.success("success")
    } catch (e: Exception) {
      result.error("SHARE_FAILED", "Failed to open share sheet", e.message)
    }
  }

  private fun shareFiles(call: MethodCall, result: Result) {
    val filePaths = call.argument<List<String>>("filePaths")
    val text = call.argument<String>("text")
    val mimeType = call.argument<String>("mimeType") ?: "*/*"

    if (filePaths.isNullOrEmpty()) {
      result.error("INVALID_PATH", "File paths cannot be null or empty", null)
      return
    }

    val context = activity ?: applicationContext
    val shareIntent = if (filePaths.size == 1) {
      Intent(Intent.ACTION_SEND).apply {
        val file = File(filePaths[0])
        if (!file.exists()) {
          result.error("FILE_NOT_FOUND", "File does not exist: ${filePaths[0]}", null)
          return
        }
        putExtra(Intent.EXTRA_STREAM, FileProvider.getUriForFile(
          context, "${context.packageName}.fileprovider", file))
      }
    } else {
      Intent(Intent.ACTION_SEND_MULTIPLE).apply {
        val uris = filePaths.map { path ->
          val file = File(path)
          if (!file.exists()) {
            result.error("FILE_NOT_FOUND", "File does not exist: $path", null)
            return
          }
          FileProvider.getUriForFile(context, "${context.packageName}.fileprovider", file)
        }
        putParcelableArrayListExtra(Intent.EXTRA_STREAM, ArrayList(uris))
      }
    }

    shareIntent.apply {
      type = mimeType
      if (!text.isNullOrEmpty()) {
        putExtra(Intent.EXTRA_TEXT, text)
      }
      if (activity == null) {
        addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
      }
      addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
    }

    val chooserIntent = Intent.createChooser(shareIntent, "Share via")
    try {
      context.startActivity(chooserIntent)
      result.success("success")
    } catch (e: Exception) {
      result.error("SHARE_FAILED", "Failed to open share sheet", e.message)
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}