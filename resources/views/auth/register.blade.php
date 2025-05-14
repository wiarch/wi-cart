@extends('layouts.auth')
@section('title', 'Registro')
@section('content')

    <h3 class="card-title text-left mb-3">Register</h3>
    <form method="POST" action="{{ route('register') }}">
        @csrf

        <div class="form-group">
            <label for="name">Username</label>
            <input id="name" name="name" type="text" class="form-control p_input" value="{{ old('name') }}" required
                autofocus>
            @error('name')
                <small class="text-danger">{{ $message }}</small>
            @enderror
        </div>

        <div class="form-group">
            <label for="email">Email</label>
            <input id="email" name="email" type="email" class="form-control p_input" value="{{ old('email') }}"
                required>
            @error('email')
                <small class="text-danger">{{ $message }}</small>
            @enderror
        </div>

        <div class="form-group">
            <label for="password">Password</label>
            <input id="password" name="password" type="password" class="form-control p_input" required
                autocomplete="new-password">
            @error('password')
                <small class="text-danger">{{ $message }}</small>
            @enderror
        </div>

        <div class="form-group">
            <label for="password_confirmation">Confirm Password</label>
            <input id="password_confirmation" name="password_confirmation" type="password" class="form-control p_input"
                required autocomplete="new-password">
            @error('password_confirmation')
                <small class="text-danger">{{ $message }}</small>
            @enderror
        </div>

        <div class="form-group d-flex align-items-center justify-content-between">
            <div class="form-check">
                <label class="form-check-label">
                    <input type="checkbox" class="form-check-input" name="remember"> Remember me
                </label>
            </div>
            <a href="{{ route('password.request') }}" class="forgot-pass">Forgot password</a>
        </div>

        <div class="text-center">
            <button type="submit" class="btn btn-primary btn-block enter-btn">Register</button>
        </div>

        <p class="sign-up text-center">Already have an Account? <a href="{{ route('login') }}">Sign In</a></p>
    </form>

@endsection
